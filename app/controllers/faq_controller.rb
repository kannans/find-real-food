class FaqController < ApplicationController
  def index
  	@faqs = Faq.all
  	
  end

  def updatedlocations
  	@records = Location.where("latitude !=''")

  	locations = Location.where("address !=''")
       state = ''
       locations.each do |l|
         location = Location.where(:id => l.id).first
         if location.zipd
          zipcode = location.zip
          connection = ActiveRecord::Base.connection()
          results = connection.execute("select STATE from master_zipcode where ZIP_CODE='#{zipcode}' limit 1")
          results.each do |row|
            state =  row[0]
          end
          location.update_attributes({
            :address => location.address,
            :zip => location.zip,
            :city => location.city,
            :state => state
           })
         end
         
       end

       
  end
end
