class PromoCode < ActiveRecord::Base
  attr_accessible :code, :user_id, :redeemed_at
  belongs_to :user
end
