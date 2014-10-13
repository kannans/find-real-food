class Subscription < ActiveRecord::Base
  PLANS = {
    "com.hitcents.realfood.sixmonths" => 6,
    "com.hitcents.realfood.oneyear" => 12
  }

  after_create :set_dates

  attr_accessible :purchased_at, :user_id, :expires_at, :subscription_type

  validates :subscription_type, :inclusion=> { :in => PLANS.map { |p| p[0] } }

  belongs_to :user

  acts_as_api

  api_accessible :subscription do |template|
    template.add :subscription_type
    template.add :purchased_at
    template.add :expires_at
  end

  private
    def set_dates
      self.purchased_at = lambda { Time.now }.call
      self.expires_at = lambda { Time.now }.call + PLANS[self.subscription_type].months
      self.save!
    end
end
