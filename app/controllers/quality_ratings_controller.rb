class QualityRatingsController < ApplicationController
  def index
  	
  	
  	#@qualityratings = organize_parent(params[:page])
    #@qualityratings = []    
  	@qualityratings  = QualityRating.paginate(page: params[:page], per_page: 5).group('category_id').order('category_id DESC')
    

  end

  def organize_parent(page)

  	qualityratings = {}
    categories = Category.paginate(page: page, per_page: 5).order('title DESC')
    categories.each do |category|
     qualityratings[category.id] ||= {}
     qualityratings[category.id] = QualityRating.where(category_id:11).all
     
    end
    return qualityratings
  end

end
