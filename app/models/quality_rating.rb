class QualityRating < ActiveRecord::Base
  belongs_to :category

  attr_accessible :name,
  								:value,
  								:category_id

  acts_as_api

  api_accessible :quality_rating do |template|
    template.add :name
    template.add :value
    template.add :category_id
  end

  def title
    "#{self.category.title} - #{self.name}"
  end

  def titleonly
    "#{self.category.title}"
  end
  
  
end
