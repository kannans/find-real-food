class UsersController < Devise::RegistrationsController
  
  param :user, Hash do
    param :email, String
    param :password, String
    param :password_confirmation, String
    param :city, String
    param :state, String
    param :facebook_id, String
    param :avatar_data, Hash, :desc => "Base64 encoded image data"
    param :cover_photo_data, Hash, :desc => "Base64 encoded image data"
  end
  
  def index
     if user_signed_in?
       @user = User.find(current_user.id)
       product_ids = Fovorite.where(user_id:current_user.id).where(type: "Product").collect{|c| c.reference_id}.join(',')
       @products = Product.where("id in (#{product_ids})") 

       product_ids_rat = Rating.where(user_id:current_user.id).where(ratable_type: "Product").collect{|c| c.ratable_id}.join(',')
       @products_rate = Product.where("id in (#{product_ids_rat})")
     else
      redirect_to "/login"
     end
  end
  
  def login

  end


  def create


    require "rubygems"
    require "active_merchant"

    ActiveMerchant::Billing::Base.mode = :test

    gateway = ActiveMerchant::Billing::PaypalGateway.new(
      :login => "PayPal_api1.RealFoodMobileApp.com",
      :password => "H53KLCUJMVQ3PU66",
      :signature => "APNTJQWHE7asaT8MlHyiwn-f0vqpAYTTim7yHx2-5zZWks5INVOKJ-on"
    )



      credit_card = ActiveMerchant::Billing::CreditCard.new(
      :type               => params[:cardtype],
      :number             => params[:cardnumber],
      :verification_value => params[:cvvnumber],
      :month              => params[:month],
      :year               => params[:year],
      :first_name         => params[:user][:fname],
      :last_name          => params[:user][:name]
    )
    
    

    if credit_card.valid?
      # or gateway.purchase to do both authorize and capture
      response = gateway.authorize(1000, credit_card, :ip => "127.0.0.1")
      if response.success?
        gateway.capture(1000, response.authorization)
        
      else
        flash[:notice] = "Error: #{response.message}"
         
      end
    else
      flash[:notice] = "Error: credit card is not valid. #{credit_card.errors.full_messages.join('. ')}"
       
    end
    
   

    build_resource(params[:user])

    begin
      resource.save!
        flash[:success] = "You have been registered successfully"
  	    redirect_to '/login'
    rescue Exception => e
        flash[:notice] = e.message
  		redirect_to '/login'
    end
  end
  
  def edit
     if user_signed_in?
    else
      redirect_to "/login"
    end
  end
  
  def editpass
    if user_signed_in?
    else
      redirect_to "/login"
    end
  end
  
  def check_email
  @user = User.find_by_email(params[:user][:email])
   
  respond_to do |format|
  format.json { render :json => !@user }
  end
  end
  

  def check_email_forgot
  @user = User.find_by_email(params[:emailaddress])
   
  respond_to do |format|
    if @user
      format.json { render :json => true}
    else
      format.json { render :json => false}
    end 
  end
  end
  
  def forgotpassword
    @user = User.find_by_email(params[:emailaddress])
    ContactMailer.forgot_mail(@user).deliver
    flash[:success] = "Your Login Credentials have been Sent to registered Email address."
    redirect_to "/login"
  end

  def update
    if user_signed_in?
    params[:user].delete(:avatar_data) if params[:user][:avatar_data].nil?
    params[:user].delete(:cover_photo_data) if params[:user][:cover_photo_data].nil?

    params[:user].delete(:password) if params[:user][:password].nil?
    params[:user].delete(:password_confirmation) if params[:user][:password].nil?

    if params[:user][:avatar_data]
      avatar_data = params[:user][:avatar_data]
      params[:user].delete(:avatar_data)
    end

    if params[:user][:cover_photo_data]
      cover_photo_data = params[:user][:cover_photo_data]
      params[:user].delete(:cover_photo_data)
    end

    begin
      current_user.avatar = RealFood::ImageDecoder.decode_jpg(avatar_data) if avatar_data
      current_user.cover_photo = RealFood::ImageDecoder.decode_jpg(cover_photo_data) if cover_photo_data

      current_user.update_attributes!(params[:user])
      flash[:success] = "Profile Details has been updated Successfully"
  	  redirect_to "/user/edit"
    rescue Exception => e
       flash[:notice] = e.message
  	   redirect_to "/user/edit"
    end
    else
      redirect_to "/login"
    end
  end
  



  def updatepass
    if user_signed_in?
    begin
      current_user.update_attributes!(params[:user])
      flash[:success] = "Password has been Changed Successfully, Please login to proceed"
      redirect_to "/login"
    rescue Exception => e
       flash[:notice] = e.message
       redirect_to "/user/editpass"
    end
    else
      redirect_to "/login"
    end
  end


end
