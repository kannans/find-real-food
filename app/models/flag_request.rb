class FlagRequest < ActiveRecord::Base
  attr_accessible :comment, :flaggable_id, :flaggable_type, :user_id, :user

  belongs_to :flaggable, :polymorphic => true
  belongs_to :user

  acts_as_api

  validate :object_flaggable
  validate :object_exists

  api_accessible :flag_request do |template|
    template.add :id
    template.add :user_id
    template.add :flaggable_type
    template.add :flaggable_id
    template.add :comment
  end

  private
    def object_flaggable
      object = self.flaggable_type.constantize rescue nil
      responds = !object.nil? && object.method_defined?(:flag_requests)
      errors.add(:base, "Object is not flaggable.") unless responds
    end

    def object_exists
      object = self.flaggable_type.constantize.find(self.flaggable_id) rescue nil
      errors.add(:base, "Invalid object ID.") if object.nil?
    end
end
