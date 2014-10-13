ActiveAdmin.register Product do
  filter :name
  filter :available
  filter :brand
  filter :approved, :as => :select
  filter :category, :as => :select

  belongs_to :brand, :optional => true

  index do
    column :name
    column :created_at
    default_actions
  end

  form :partial => "form"

  collection_action :list_ratings, :method => :get do
    params[:category_id]
    @data_for_select2 = QualityRating.where(:category_id => params[:category_id]).all
    render :json => @data_for_select2.map{|c| [c.id, c.name]}
  end
end
