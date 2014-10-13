ActiveAdmin.register FlagRequest do
   actions :index, :show, :destroy
   filter :user
   filter :created_at
end
