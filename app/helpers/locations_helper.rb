module LocationsHelper

	def get_state_name(state_id=nil)
     
     if State.exists?(state_id)
       state = State.find(state_id)
       return state.name ? state.name : ''
     else
       return 
     end 
  end

end
