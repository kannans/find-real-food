class Apiv1::QualityRatingsController < ApplicationController

  api :GET, '/quality_ratings', 'Get a listing of all quality ratings.'
  def index
    @ratings = QualityRating.all
    respond_to do |format|
      format.json { render_for_api :quality_rating, :json => @ratings,
        :meta => { :success => true}, :root => :quality_rating}
    end
  end

end
