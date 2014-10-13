ActiveAdmin.register Subscription do
  form do |f|
    f.inputs "Subscription" do
      f.input :user
      f.input :subscription_type, :as => :select, :collection => {'6 Months' => 'com.hitcents.realfood.sixmonths' ,'12 months' => 'com.hitcents.realfood.oneyear'}
    end
    f.actions
  end
end
