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
    self.unscoped.quality_rating_search_web(location).where(category_id: category_id)
              .order("avg_rating desc")
              .order("quality_order asc")
              .order("products.name asc")
              .find(:all, :limit => 20)
  end
  
  def self.search_products(location='')
    self.unscoped.quality_rating_search_web(location)
  end

  def selected_parents
    self.locations.where("parent_id is null").pluck(:id)
  end

  private
    def self.quality_rating_search_web(params='')
      if params !=''
      self.joins("LEFT OUTER JOIN quality_ratings ON quality_ratings.id = products.quality_rating_id")
          .joins("LEFT OUTER JOIN ratings ON ratable_id = products.id AND ratable_type = 'Product'")
          .joins("LEFT OUTER JOIN locations_products ON locations_products.product_id = products.id")
          .joins("RIGHT JOIN brands ON products.brand_id=brands.id ")
          .group("products.id")
          .select("products.*,
                CASE quality_ratings.name
                    WHEN 'Best' THEN 1
                    WHEN 'Good' THEN 2
                    WHEN 'Avoid' THEN 3
                END As quality_order, locations_products.location_id as location_id, products.brand_id as brand_id")
          .select("count(ratings.rating) as rating_count,AVG(ratings.rating) as avg_rating")
          .where("products.quality_rating_id IS NOT NULL and locations_products.location_id in (#{params})")
        else

      self.joins("LEFT OUTER JOIN quality_ratings ON quality_ratings.id = products.quality_rating_id")
          .joins("LEFT OUTER JOIN ratings ON ratable_id = products.id AND ratable_type = 'Product'")
          .joins("RIGHT JOIN brands ON products.brand_id=brands.id")
          .group("products.id")
          .select("products.*,
                CASE quality_ratings.name
                    WHEN 'Best' THEN 1
                    WHEN 'Good' THEN 2
                    WHEN 'Avoid' THEN 3
                END As quality_order, products.brand_id as brand_id")
          .select("count(ratings.rating) as rating_count,AVG(ratings.rating) as avg_rating")
          
        end
    end
    
    def self.quality_rating_search
      self.joins("LEFT OUTER JOIN quality_ratings ON quality_ratings.id = products.quality_rating_id")
          .joins("LEFT OUTER JOIN ratings ON ratable_id = products.id AND ratable_type = 'Product'")
          .group("products.id")
          .select("products.*,
                CASE quality_ratings.name
                    WHEN 'Best' THEN 1
                    WHEN 'Good' THEN 2
                    WHEN 'Avoid' THEN 3
                END As quality_order")
          .select("AVG(ratings.rating) as avg_rating, products.*")
          .where("products.quality_rating_id IS NOT NULL")
    end

    def skip_check
      return false if self.skip_processing
    end
    


    def self.searchtext(search='')
      if search
        find(:all, :conditions => ['products.name LIKE ?', "%#{search}%"])
      else
        find(:all)
      end
    end
   
   def self.sortorder(sort='')
      
      if sort=='alphabetical' || sort =='alphabetical'
          order("products.name asc")
         .order("avg_rating desc")
         .order("quality_order asc") 
      else
         order("avg_rating desc")
         .order("quality_order asc")  
         .order("products.name asc") 
      end
    end

    def self.categoryfilter(category_id)
     if category_id.to_i > 0
        where category_id: category_id 
      else
        where("products.name IS NOT NULL")
      end
    end
    

    def self.categorysearch(categories='')
     if categories!=''
        where("products.category_id in (#{categories})")
     end
    end


    def self.brandfilter(brand_id)
      if brand_id.to_i > 0
        where brand_id: brand_id 
      else
        where("products.name IS NOT NULL")
      end
    end
    
    def self.qualityfilter(rank='')
      if rank =='good' || rank =='best' 
      where("quality_ratings.name = '#{rank}'")
      else
      where("quality_ratings.name = 'good' || quality_ratings.name = 'best'")
      end
    end

     def self.availabilityfilter(sold='')
      if sold =='store'
        where("brands.store_farmers_market = '1'")
      elsif sold =='phone'
        where("brands.order_by_phone = '1'")
      elsif sold=='online'
         where("brands.order_by_online = '1'")
      elsif sold =='all'
        where("brands.order_by_online = '1' and brands.order_by_phone = '1' and brands.store_farmers_market = '1'")
      else
        where("brands.order_by_online = '1' or brands.order_by_phone = '1' or brands.store_farmers_market = '1'")
      end
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
