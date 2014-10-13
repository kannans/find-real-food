class Feedback < ActiveRecord::Base
  belongs_to :user

  attr_accessible :message, :subject, :user_id

  acts_as_api

  api_accessible :feedback do |template|
    template.add :user_id
    template.add :subject
    template.add :message
  end
end
