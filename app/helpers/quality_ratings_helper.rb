module QualityRatingsHelper
  def get_quality(category=nil)
    return QualityRating.where(category_id:category).all
     
  end
end
