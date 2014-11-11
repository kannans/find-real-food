class FaqController < ApplicationController
  def index
  	@faqs = Faq.all

  end

  def updatedlocations
  	@records = Location.where("latitude !=''")
  end
end
