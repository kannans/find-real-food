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
   

end
