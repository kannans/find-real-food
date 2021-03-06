class UsersController < Devise::RegistrationsController
  
  param :user, Hash do
    param :email, String
    param :password, String
    param :password_confirmation, String
    param :city, String
    param :state, String
    param :facebook_id, String
    param :avatar, Hash, :desc => "Base64 encoded image data"
    param :cover_photo, Hash, :desc => "Base64 encoded image data"
  end
  
  def index
     if user_signed_in?
       @user = User.find(current_user.id)
       product_ids = Fovorite.where(user_id:current_user.id).where(type: "Product").collect{|c| c.reference_id}.join(',')
       if product_ids !=''
        @products = Product.where("id in (#{product_ids})") 
       end

       product_ids_rat = Rating.where(user_id:current_user.id).where(ratable_type: "Product").collect{|c| c.ratable_id}.join(',')
       if product_ids_rat !=''
        @products_rate = Product.where("id in (#{product_ids_rat})")
       end
     else
      redirect_to "/login"
     end
  end
  
  def login
    if user_signed_in?
      redirect_to "/user/profile"
    end
  end


  def create

   build_resource(params[:user])

    begin
      resource.save!
      sign_in(:user, resource)
      flash[:success] = "You have been registered successfully"
      redirect_to '/user/profile'
    rescue Exception => e
        flash[:notice] = e.message
  		redirect_to '/login'
    end
  end
  
  def edit
     
    
    
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
  @user = User.find_by_email(params[:email])
   
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
    params[:user].delete(:password) if params[:user][:password].nil?
    params[:user].delete(:password_confirmation) if params[:user][:password].nil?
    begin
      # current_user.avatar = RealFood::ImageDecoder.decode_jpg(avatar_data) if avatar_data
      # current_user.cover_photo = RealFood::ImageDecoder.decode_jpg(cover_photo_data) if cover_photo_data
      current_user.update_attributes!(params[:user])
      flash[:success] = "Profile Details has been updated Successfully"
  	  redirect_to "/user/profile"
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
