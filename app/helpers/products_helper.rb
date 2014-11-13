module ProductsHelper

  def total_rating(product_id)
    return Rating.where(ratable_id:product_id).count
  end

  def get_rating_list(product_id)
  	return Rating.where(ratable_id: product_id).where(ratable_type: "Product").paginate(page: 1, per_page: 3).order("id desc")
  end

end
