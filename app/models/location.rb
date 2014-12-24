class Location < ActiveRecord::Base
  TYPES = ['National Retailer', 'Local Retailer', 'Farm Store', 'Co-Op/Buying Club', 'Farmer\'s Market']
  
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  #belongs_to :state
  belongs_to :brand

  has_many :ratings, :as => :ratable

  has_and_belongs_to_many :products
  has_and_belongs_to_many :brands

  belongs_to :parent, :class_name => 'Location'
  has_many :children, :class_name => 'Location', :foreign_key => :parent_id

  #validates :location_type, :inclusion => { :in => TYPES }

  attr_accessible :address,
  								:city,
  								:hours,
  								:name,
  								:phone,
  								:website,
  								:zip,
  								:state_id,
                  :picture,
                  :parent_id,
                  :location_type,
                  :state,
                  :parent,
                  :location_code

  has_attached_file :picture,
    :styles => { :thumb => "100x39#", :small  => "300x117#", :full => "640x250#" },
    :default_url => "/assets/blank.png"
  
  acts_as_api

  api_accessible :location do |template|
     template.add :products, :template => :product
     template.add :brands, :template => :brand
  end

  # with an attributes
 # geocoded_by :address # address is an attribute of MyModel

  # or with a method
  geocoded_by :full_address # full_address is a method which  take some model's attributes to get a formatted address for example

  # the callback to set longitude and latitude
  after_validation :geocode

  # the full_address method
  def full_address
    "#{address}, #{zip}, #{city}, USA"
  end
  
  
  def self.parent_locations
    self.where(:parent_id => nil)
  end

  def self.child_locations
    self.where("parent_id is not null").order(:parent_id)
  end

  def children_ids
    self.children.pluck(:id)
  end
end
