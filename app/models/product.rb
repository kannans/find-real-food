class Product < ActiveRecord::Base
  
  extend FriendlyId
  friendly_id :name, use: :slugged

  #before_save :process_parent_ids

  belongs_to :category
  belongs_to :brand
  belongs_to :quality_rating
  belongs_to :user

  has_many :ratings, :as => :ratable
  has_many :flag_requests, :as => :flaggable

  has_and_belongs_to_many :locations

  attr_accessor :skip_processing, :parent_ids
  attr_accessible :available,
  								:name,
  								:category_id,
  								:brand_id,
  								:quality_rating_id,
                  :picture,
                  :approved,
                  :image_data,
                  :skip_processing,
                  :user,
                  :user_id,
                  :parent_ids,
                  :location_ids

  has_attached_file :picture,
    :styles => { :thumb => "100x100#", :small  => "499x203#", :full => "640x250#" },
     :default_url => ""
    

  acts_as_api

  #default_scope order('products.name ASC')
  scope :approved, where(:approved => true)

  delegate :name,  :to => :brand,    :prefix => :brand
  delegate :title, :to => :category, :prefix => :category

  before_post_process :skip_check

  api_accessible :product do |template|
    template.add  :id
    template.add  :available
    template.add  :name
    template.add  :category_id
    template.add  :category_title, :unless => lambda { |p| p.category_id.nil? }
    template.add  :brand_id
    template.add  :brand_name, :unless => lambda { |p| p.brand_id.nil? }
    template.add  :quality_rating_id
    template.add  :quality
    template.add  :picture, :as => :image
    template.add  :approved
    template.add  :rating
    template.add  :comments, :template => :rating
    template.add  :user, :template => :user_basic, :if => lambda { |p| !p.user.nil? && !p.user.private }
    template.add  :brand, :template => :brand
  end

  def quality
    return self.quality_rating.name unless self.quality_rating.nil?
    ""
  end

  def rating
    return 0 if self.ratings.length == 0
    self.ratings.sum(:rating) / self.ratings.length
  end
  
  def comments
    self.ratings.joins(:user).where("users.private != true").order("created_at DESC").limit(5)
  end

  def self.search_and_sort_by_rating(params)
    self.unscoped.quality_rating_search
        .order("avg_rating desc")
        .order("quality_order asc")
        .order("products.name asc")
        .search(params)
  end
 

  def self.search_and_sort_by_quality(params)
    self.unscoped.quality_rating_search
        .order("quality_order asc")
        .order("avg_rating desc")
        .order("products.name asc")
        .search(params)
  end

  def self.similar_products(location='', category_id='')
    self.unscoped.quality_rating_search(location).where(category_id: category_id)
              .order("avg_rating desc")
              .order("quality_order asc")
              .order("products.name asc")
              .find(:all, :limit => 20)
  end

  def self.sort_by_rating(location='',search='', category='', brand='', sort='')
    
      if category !=''
        if search !=''
            if sort =='proximity' || sort =='alphabetical'
              self.unscoped.quality_rating_search(location).where(category_id: category.id)
              .order("products.name asc")
              .order("avg_rating desc")
              .order("quality_order asc")              
              .find(:all, :conditions => ['products.name LIKE ?', "%#{search}%"], :limit => 20)
            else
              self.unscoped.quality_rating_search(location).where(category_id: category.id)
              .order("avg_rating desc")
              .order("quality_order asc")
              .order("products.name asc")
              .find(:all, :conditions => ['products.name LIKE ?', "%#{search}%"], :limit => 20)
            end

         else
          self.unscoped.quality_rating_search(location).where(category_id: category.id)
        .order("avg_rating desc")
        .order("quality_order asc")
        .order("products.name asc")
        .find(:all, :conditions => ['products.name IS NOT NULL'], :limit => 20)
         end 
      elsif brand !=''
      self.unscoped.quality_rating_search(location).where(brand_id: brand.id)
        .order("avg_rating desc")
        .order("quality_order asc")
        .order("products.name asc")
        .find(:all, :conditions => ["products.name IS NOT NULL"], :limit => 20)
      else
        if search !=''
            if sort =='proximity' || sort =='alphabetical'
              self.unscoped.quality_rating_search(location)
              .order("products.name asc")
              .order("avg_rating desc")
              .order("quality_order asc")
              .find(:all, :conditions => ['products.name LIKE ?', "%#{search}%"], :limit => 20)
            else
              self.unscoped.quality_rating_search(location)
              .order("avg_rating desc")
              .order("quality_order asc")
              .order("products.name asc")
              .find(:all, :conditions => ['products.name LIKE ?', "%#{search}%"], :limit => 20)
            end 
        else
         self.unscoped.quality_rating_search(location)
        .order("avg_rating desc")
        .order("quality_order asc")
        .order("products.name asc")
        .find(:all, :conditions => ['products.name IS NOT NULL'], :limit => 20) 
        end
      end
    
  end

  def selected_parents
    self.locations.where("parent_id is null").pluck(:id)
  end

  private
    def self.quality_rating_search(params='')
      if params !=''
      self.joins("LEFT OUTER JOIN quality_ratings ON quality_ratings.id = products.quality_rating_id")
          .joins("LEFT OUTER JOIN ratings ON ratable_id = products.id AND ratable_type = 'Product'")
          .joins("LEFT OUTER JOIN locations_products ON locations_products.product_id = products.id")
          .group("products.id")
          .select("products.*,
                CASE quality_ratings.name
                    WHEN 'Best' THEN 1
                    WHEN 'Good' THEN 2
                    WHEN 'Avoid' THEN 3
                END As quality_order, locations_products.location_id as location_id")
          .select("count(ratings.rating) as rating_count,AVG(ratings.rating) as avg_rating, products.*")
          .where("products.quality_rating_id IS NOT NULL and locations_products.location_id in (#{params})")
        else

      self.joins("LEFT OUTER JOIN quality_ratings ON quality_ratings.id = products.quality_rating_id")
          .joins("LEFT OUTER JOIN ratings ON ratable_id = products.id AND ratable_type = 'Product'")
          .group("products.id")
          .select("products.*,
                CASE quality_ratings.name
                    WHEN 'Best' THEN 1
                    WHEN 'Good' THEN 2
                    WHEN 'Avoid' THEN 3
                END As quality_order")
          .select("count(ratings.rating) as rating_count,AVG(ratings.rating) as avg_rating, products.*")
          
        end
    end

    def skip_check
      return false if self.skip_processing
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
end
