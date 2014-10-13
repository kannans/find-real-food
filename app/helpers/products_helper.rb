module ProductsHelper

  def total_rating(product_id)
    return Rating.where(ratable_id:product_id).count
  end


end
