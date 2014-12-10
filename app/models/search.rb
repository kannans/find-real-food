class Search < ActiveRecord::Base
  #self.table_name = 'news_posts' #temporary fix. need to figure out how to get this model to just include ActiveModel


  attr_accessor :products, :brands, :categories, :users, :locations, :pages

  acts_as_api

   
end
