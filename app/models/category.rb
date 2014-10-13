class Category < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  acts_as_api

  attr_accessible :title, :sort, :picture, :created_at, :updated_at
  has_many :quality_ratings
  has_attached_file :picture,
    :styles => { :thumb => "239x240#", :small => "300x117#", :full => "640x250#" },
    :default_url => ""
  default_scope order('title ASC')

  api_accessible :category do |template|
    template.add :id
    template.add :title
    template.add :picture, :as => :image


  end
end
