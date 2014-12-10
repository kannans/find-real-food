class Search < ActiveRecord::Base
  self.table_name = 'news_posts' #temporary fix. need to figure out how to get this model to just include ActiveModel


  attr_accessor :products, :brands, :categories, :users, :locations, :pages

  acts_as_api

  api_accessible :search do |template|
    template.add :products, :template => :product
    template.add :brands, :template => :brand
    template.add :categories, :template => :category
    template.add :users, :template => :user
    template.add :locations, :template => :location
    template.add :pages
  end
end
