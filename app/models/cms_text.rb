class CmsText < ActiveRecord::Base
  attr_accessible :key, :value

  acts_as_api

  api_accessible :cms_text do |template|
    template.add :key
    template.add :value
  end
end
