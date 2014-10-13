class Slider < ActiveRecord::Base
  attr_accessible :approved, :picture, :title, :url, :slider_text
  has_attached_file :picture,
    :styles => { :thumb => "100x39#", :small => "300x117#", :full => "1600x410#" },
    :default_url => ""
 before_save :format_url
 validates :url, :presence => {:message => 'Should not be empty'}, :format => {:with => /\A(http|https):\/\/[a-z0-9]+[A-Za-z0-9._%+-]+\.[A-Za-z]+\z/, :message => 'Please enter valid URL'}

 
 validates :picture, :presence=>true
 
def format_url
  self.url = "http://#{self.url}" unless self.url[/^https?/]    
end

end
