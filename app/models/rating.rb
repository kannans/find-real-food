class Rating < ActiveRecord::Base
  attr_accessible :ratable_id, :ratable_type, :rating, :user_id, :comment, :created_at, :updated_at

  validate :rating, inclusion: { in: 1..5}

  validate :object_ratable
  validate :object_exists

  validates_uniqueness_of :user_id, {
    :scope => [:ratable_id, :ratable_type],
    :message => "has already rated this item."
  }

  belongs_to :ratable, :polymorphic => true
  belongs_to :user

  acts_as_api

  api_accessible :rating do |template|
    template.add :id
    template.add :rating
    template.add :comment
    template.add :user, :template => :user_basic
    template.add :created_at
  end

  private
    def object_ratable
      object = self.ratable_type.constantize rescue nil
      responds = !object.nil? && object.method_defined?(:ratings)
      errors.add(:base, "Object is not ratable.") unless responds
    end

    def object_exists
      object = self.ratable_type.constantize.find(self.ratable_id) rescue nil
      errors.add(:base, "Invalid object ID.") if object.nil?
    end
end
