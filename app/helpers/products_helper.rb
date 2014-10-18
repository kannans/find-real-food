module ProductsHelper

  def total_rating(product_id)
    return Rating.where(ratable_id:product_id).count
  end

  def get_rating_list(product_id)
  	return Rating.where(ratable_id:product_id).last(5)
  end

end
