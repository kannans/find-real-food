class User < ActiveRecord::Base
  has_attached_file :avatar, :default_url => ""
  has_attached_file :cover_photo, :default_url => ""

  devise :database_authenticatable, :registerable, :omniauthable, 
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

	attr_accessible :database_authenticatable, :registerable, :email, :password,
         					:recoverable, :rememberable, :trackable, :validatable, :token_authenticatable,
                  :name, :fname, :city, :state, :facebook_id, :avatar, :avatar_file_name,
                  :avatar_file_size, :password_confirmation, :avatar_data,
                  :cover_photo_data, :cover_photo, :cover_photo_file_name,
                  :cover_photo_file_size, :private, :bio, :pro_account

  before_save :ensure_authentication_token
  before_create { generate_token(:auth_token) }
  has_many :flag_requests
  has_many :feedbacks
  has_many :ratings
  has_many :products
  has_many :brands
  has_many :subscriptions
  has_one  :promo_code

	acts_as_api

  default_scope order('name ASC')

	api_accessible :user do |template|
		template.add :id
		template.add :email
		template.add :authentication_token
		template.add :password
    template.add :name
    template.add :city
    template.add :state
    template.add :facebook_id
    template.add :avatar
    template.add :cover_photo
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

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.save!
    end
  end

  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(name:auth.extra.raw_info.name,
                            provider:auth.provider,
                            uid:auth.uid,
                            email:auth.info.email,
                            password:Devise.friendly_token[0,20],
                          )
      end    end
  end
end
