module ApplicationHelper
	
	def build_resource(hash=nil)
  	self.resource = resource_class.new_with_session(hash || {}, session)
	end

	def resource_name
    :user
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

  def get_state_list
       return State.all
  end
   
  def get_location_count(product_id='',locations='')
    
      connection = ActiveRecord::Base.connection()
      results = connection.execute("select count(*) from locations_products where product_id=#{product_id} and location_id in (#{locations}) ")
      results.each do |row|
         return row[0]
      end

  end

  def get_locations_list(product_id='',locations='')
    
      connection = ActiveRecord::Base.connection()

      return results = connection.execute("select * from locations where  id in (select id from locations_products where product_id=#{product_id} and location_id in (#{locations})) ")
       

  end
  def get_prod_locations_list(locations='')
    
      connection = ActiveRecord::Base.connection()

      return results = connection.execute("select * from locations where  id in (select id from locations_products where location_id in (#{locations})) ")
       
  end

  def get_statename(state_id=nil)
     
     if State.exists?(state_id)
       state = State.find(state_id)
       return state.name ? state.name : ''
     else
       return 
     end 
  end

end
