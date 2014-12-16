module ApplicationHelper
	
	def build_resource(hash=nil)
  	self.resource = resource_class.new_with_session(hash || {}, session)
	end

	def resource_name
    :user
  end

  def signed_in?
  !current_user.nil?
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def get_brandname(brand_id=nil)
     
     if Brand.exists?(brand_id)
       brand = Brand.find(brand_id)
       return brand.name ? brand.name : ''
     else
       return 
     end 
  end

  def get_brand_details(brand_id=nil)
     
     if Brand.exists?(brand_id)
       return Brand.find(brand_id)
       
     else
       return 
     end 
  end

  def get_user_details(user_id=nil)
    if User.exists?(user_id)
       return User.find(user_id)
     else
       return 
     end 
  end
  

  def numeric?
    Float(self) != nil rescue false
  end
  
  def get_state_list
       return State.all
  end
  
  def get_quality_name(id)
    qualityval = QualityRating.where(id: id).first
    if qualityval
      return qualityval.name
    else
      return ""
    end
  end
  def get_location_count(product_id='',locations='')
    
      connection = ActiveRecord::Base.connection()
      results = connection.execute("select count(*) from locations_products where product_id=#{product_id} and location_id in (#{locations}) group by location_id")
      results.each do |row|
         return row[0]
      end

  end

  def getlocationslist(product_id='',locations='')
    
      subquery = "select location_id from locations_products where product_id=#{product_id} and location_id in (#{locations})"
      return Location.where("locations.id IN (#{subquery})")


  end

  def get_brand_location_count(brand_id='',locations='')
    
      connection = ActiveRecord::Base.connection()
      results = connection.execute("select count(*) from brands_locations where brand_id=#{brand_id} and location_id in (#{locations}) ")
      results.each do |row|
         return row[0]
      end

  end

  def get_brand_locations_list(brand_id='',locations='')
    
      connection = ActiveRecord::Base.connection()

      return results = connection.execute("select * from locations where  id in (select location_id from brands_locations where brand_id=#{brand_id} and location_id in (#{locations})) ")

  end

  def get_prod_locations_list(locations='')
    
      connection = ActiveRecord::Base.connection()

      return results = connection.execute("select * from locations where  id in (select location_id from locations_products where location_id in (#{locations})) ")
       
  end

  def get_statename(state_id=nil)
     
     if State.exists?(state_id)
       state = State.find(state_id)
       return state.name ? state.name : ''
     else
       return 
     end 
  end

  def relative_time(start_time)
  diff_seconds = Time.now - start_time
  diff_seconds = diff_seconds.to_i
  case diff_seconds
    when 0 .. 59
      return "#{diff_seconds} seconds ago"
    when 60 .. (3600-1)
      return "#{diff_seconds/60} minutes ago"
    when 3600 .. (3600*24-1)
      return "#{diff_seconds/3600} hours ago"
    when (3600*24) .. (3600*24*30) 
      return "#{diff_seconds/(3600*24)} days ago"
    else
      return start_time.strftime("%m/%d/%Y")
  end
end

end
