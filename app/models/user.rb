class User < ActiveRecord::Base
  # has_attached_file :avatar, :default_url => ""
  # has_attached_file :cover_photo, :default_url => ""

  devise :database_authenticatable, :registerable, :omniauthable, 
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

	attr_accessible :database_authenticatable, :registerable, :email, :password,
         					:recoverable, :rememberable, :trackable, :validatable, :token_authenticatable,
                  :name, :fname, :city, :state, :facebook_id, 
                  :password_confirmation, :private, :bio, :pro_account, 
                  :provider, :uid, 
                  :avatar,:cover_photo

  before_save :ensure_authentication_token
  before_create { generate_token(:authentication_token) }
  has_many :flag_requests
  has_many :feedbacks
  has_many :ratings
  has_many :products
  has_many :brands
  has_many :subscriptions
  has_one  :promo_code

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>", :baner => "800x300" }, :default_url => "/avatars/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  # validates_attachment :avatar, :presence => false, :content_type => {:content_type => /\Aimage\/.*\Z/}

  has_attached_file :cover_photo, :styles => { :medium => "300x300>", :thumb => "100x100>", :baner => "800x300", :big => "1600x250" }, :default_url => "/avatars/:style/missing.png"
  validates_attachment_content_type :cover_photo, :content_type => /\Aimage\/.*\Z/
  # validates_attachment :cover_photo, :presence => false, :content_type => {:content_type => /\Aimage\/.*\Z/}

	acts_as_api

  default_scope order('name ASC')

	api_accessible :user do |template|
		template.add :id
		template.add :email
		template.add :authentication_token
	# 	template.add :password
    template.add :name
    template.add :city
    template.add :state
    template.add :facebook_id
    template.add :avatar_url, :as=>:avatar
    template.add :cover_photo_url, :as=>:cover_photo
    template.add :private
    template.add :created_at
    template.add :bio

    template.add lambda{ |user| user.activities  }, :as => :activities
    template.add :subscriptions, :template => :subscription
    template.add :active_subscription
    template.add :subscription_type
    template.add :stats
	end

  api_accessible :user_basic do |template|
    template.add :id
    template.add :avatar
    template.add :name
    template.add :facebook_id
    template.add :stats
  end

  def avatar_url
    avatar.url
  end

  def cover_photo_url
    cover_photo.url
  end

  def send_password_reset
  generate_token(:reset_password_token)
  self.reset_password_sent_at = Time.zone.now
  save!
  ContactMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def subscription_type
    now = lambda { Time.now.utc }.call
    subscriptions = self.subscriptions
    return "trial" if now <= self.created_at + 14.days && !subscriptions.any?
    sub = subscriptions.where("purchased_at <= ? AND expires_at > ?", now, now).first
    return "" if sub.nil?
    return sub.subscription_type
  end

  def active_subscription
    now = lambda { Time.now.utc }.call

    return true if now <= self.created_at + 14.days
    subscriptions = self.subscriptions.where("purchased_at <= ? AND expires_at > ?", now, now)
    subscriptions.length >= 1
  end

  def activities
    products = self.products.map { |p| { :id => p.id, :name => p.name, :image => p.picture, :created_at => p.created_at, :category_id => p.category.nil? ? nil : p.category.id } }
    reviews = self.ratings.map { |r| { :id => r.id, :rating => r.rating, :comment => r.comment, :image => r.ratable.picture, :name => r.ratable.name, :ratable_type => r.ratable_type, :ratable_id => r.ratable_id, :created_at => r.created_at, :category_id => r.ratable_type == 'Product' ? r.ratable.category_id : "" } }
    brands = self.brands.map { |b| { :id => b.id, :name => b.name, :image => b.picture, :created_at => b.created_at } }
    { :products => products, :reviews => reviews, :brands => brands }
  end

  def stats
    stats = {}
    stats[:products] = self.products.count
    stats[:locations] = 0
    stats[:reviews] = self.ratings.count
    stats[:pro] = self.pro_account
    stats
  end

  # def self.from_omniauth(auth)
  #   where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
  #     user.provider = auth.provider
  #     user.uid = auth.uid
  #     user.name = auth.info.name
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token[0,20]
  #     user.save!
  #   end
  # end

  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    debugger
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      User.save_avatar(user, auth) unless user.avatar_file_name 
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        registered_user.update_attributes({
          provider:auth.provider,
          uid:auth.uid,
        })
        save_avatar registered_user, auth unless registered_user.avatar_file_name
        return registered_user
      else

        user_date = {
          fname:auth.extra.raw_info.first_name,
          name:auth.extra.raw_info.last_name,
          provider:auth.provider,
          uid:auth.uid,
          email:auth.info.email,
          password:Devise.friendly_token[0,20]
        }
        created_user = User.create(user_date)
        save_avatar(created_user, auth)
        created_user
      end
    end
  end

private
  def self.save_avatar user, auth
      if user && graph = Koala::Facebook::API.new(auth.credentials.token)
        fb_profile = graph.get_object('me')
        avatar_url = graph.get_picture(fb_profile['id'], type: :small)
        user.update_attribute(:avatar,open(avatar_url))
      end
  end
end
