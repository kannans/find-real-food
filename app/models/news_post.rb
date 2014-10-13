class NewsPost < ActiveRecord::Base

  extend FriendlyId
  friendly_id :title, use: :slugged

  attr_accessible :title,
  								:picture,
  								:author,
  								:website,
  								:body
  has_attached_file :picture,
    :styles => {
      :thumb => "100x39#",
      :small  => "370x150#",
      :full => "640x250#"
    }

  acts_as_api

  api_accessible :news_post do |template|
    template.add :title
    template.add :picture
    template.add :author
    template.add :website
    template.add :body
    template.add :full_image, :as => :picture
    template.add :created_at
  end

  def full_image
    self.picture(:full)
  end
end
