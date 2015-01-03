class Brand < ActiveRecord::Base
  
  extend FriendlyId
  friendly_id :name, use: :slugged

  #validates :website, :presence => {:message => 'Should not be empty'}, :format => {:with => /\A(http|https):\/\/[a-z0-9]+[A-Za-z0-9._%+-]+\.[A-Za-z]+\z/, :message => 'Please enter valid Website'}

  alias_attribute :store_or_farmers_market, :store_farmers_market
  #before_save :process_parent_ids, :save_location, :format_url

  attr_accessor :skip_processing, :parent_ids, :location
  attr_accessible :store_or_farmers_market,
                  :store_farmers_market,
  								:name,
  								:order_by_online,
  								:order_by_phone,
  								:phone,
  								:third_party_available,
  								:website,
                  :picture,
                  :approved,
                  :image_data,
                  :skip_processing,
                  :store_locator_url,
                  :location_ids,
                  :parent_ids,
                  :location,
                  :locations,
                  :locations_attributes,
                  :brand_code

  validates :name, presence: true

  has_attached_file :picture,
    :styles => { :thumb => "100x100#", :small => "300x117#", :full => "640x250#" },
    :default_url => ""

  has_many :products
  has_many :ratings, :as => :ratable
  has_many :flag_requests, :as => :flaggable


  has_and_belongs_to_many :locations
  accepts_nested_attributes_for :locations

  belongs_to :user

  default_scope order('brands.name ASC')
  scope :approved, where(:approved => true)

  before_post_process :skip_check

  acts_as_api

  api_accessible :brand do |template|
    template.add :id
    template.add :store_farmers_market, :as => :store_or_farmers_market
    template.add :name
    template.add :order_by_online
    template.add :order_by_phone
    template.add :phone
    template.add :third_party_available
    template.add :website
    template.add lambda{|model| model.picture(:full) }, :as => :image
    template.add :approved
    template.add :store_locator_url
    template.add :user, :template => :user_basic, :if => lambda { |b| !b.user.nil? && !b.user.private }
  end

   api_accessible :brandcount do |template|
    template.add :id
   end


  def format_url
  self.website = "http://#{self.url}" unless self.website[/^https?/]    
  end
  def selected_parents
    self.locations.where("parent_id is null").pluck(:id)
  end
  
  def self.search_brands(locations='')
    self.unscoped.brand_search(locations)
  end

  def self.search_by_locations_and_name(locations='', search='', sold='')
    
   if sold == 'phone'
    self.unscoped.brand_search(locations)
        .order("brands.name asc")
        .where(order_by_phone: 1) 
         .find(:all, :conditions => ['brands.name LIKE ?', "%#{search}%"])
   elsif sold =='online'
    self.unscoped.brand_search(locations)
        .order("brands.name asc")
        .where(order_by_online: 1) 
         .find(:all, :conditions => ['brands.name LIKE ?', "%#{search}%"])
   elsif sold =='store'
    self.unscoped.brand_search(locations)
        .order("brands.name asc")
        .where(third_party_available: 1) 
         .find(:all, :conditions => ['brands.name LIKE ?', "%#{search}%"])
   elsif sold =='all'
    self.unscoped.brand_search(locations)
        .order("brands.name asc")
        .where(order_by_phone: 1, order_by_online: 1, store_farmers_market: 1) 
         .find(:all, :conditions => ['brands.name LIKE ?', "%#{search}%"])
   else
    self.unscoped.brand_search(locations)
        .order("brands.name asc")
         .find(:all, :conditions => ['brands.name LIKE ?', "%#{search}%"])
    end
  end
  
  def self.availabilityfilter(sold='')
      if sold =='store'
        where("brands.third_party_available = '1'")
      elsif sold =='phone'
        where("brands.order_by_phone = '1'")
      elsif sold=='online'
         where("brands.order_by_online = '1'")
      elsif sold =='all'
        where("brands.order_by_online = '1' and brands.order_by_phone = '1' and brands.store_farmers_market = '1'")
      else
        where("brands.order_by_online = '1' or brands.order_by_phone = '1' or brands.store_farmers_market = '1' or brands.third_party_available = '1'")
      end
  end

  def self.searchtext(search='')
      if search
        find(:all, :conditions => ['brands.name LIKE ?', "%#{search}%"])
      else
        find(:all)
      end
  end
  
  private
    def skip_check
      return false if self.skip_processing
    end

    def sized_picture
      self.picture(:full)
    end

    def process_parent_ids
      return unless parent_ids.any?
      self.parent_ids = self.parent_ids.reject! { |c| c.empty? }

      parents = Location.find(self.parent_ids)

      parents.each do |parent|
        self.location_ids += parent.children_ids + [parent.id]
      end

      self.location_ids = self.location_ids.uniq
    end

    def save_location
      return if self.location[:name].empty?
      self.location[:state_id] = self.location[:state]
      self.location[:parent_id] = self.location[:parent]
      self.location.delete(:state)
      self.location.delete(:parent)
      location = Location.create(self.location)
      self.locations << location
    end

    def self.brand_search(params='')
      if params !=''
      self.joins("LEFT OUTER JOIN brands_locations ON brands_locations.brand_id = brands.id")
          .group("brands.id")
          .select("brands.*")
          .where("brands_locations.location_id in (#{params})")
      else
      self.group("brands.id")
          .select("brands.*")
      
        
      end
    end

end
