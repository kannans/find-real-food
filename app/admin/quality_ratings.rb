ActiveAdmin.register QualityRating do
  filter :name
  filter :value
  filter :category

  belongs_to :category, :optional => true

  index do
    column :name
    column :value
    column :created_at
    column :category
    default_actions
  end
end
