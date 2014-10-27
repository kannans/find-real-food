RealFood::Application.routes.draw do

  

  
  mount Ckeditor::Engine => '/ckeditor'

  get "locations/index"

   get "home/index"

  apipie

  devise_for :users, :controllers => { :registrations => 'registrations', :omniauth_callbacks => "omniauth_callbacks"}
  devise_scope :user do
    #get 'login',  :to => 'devise/sessions#new'
    get 'logout', :to => 'devise/sessions#destroy'
    get 'signup', :to => 'devise/registrations#new'
     
    # K2B Routes code
    get 'user/profile', :to => 'users#index'
    get 'user/edit', :to => 'users#edit'
    get 'login', :to => 'users#login'
    post 'sessions/create'
    post 'users/create'
    get 'logout', :to => 'sessions#destroy'
    
    
    get 'brands/addtofavorite', :to => 'brands#add_to_favorites'
    get 'location/:slug', :to => 'locations#index'
    get 'brands/addflag', :to => 'brands#add_flag'

    post 'locations/create'
    
    get 'products', :to => 'products#index'
    get 'products/addtofavorite', :to => 'products#add_to_favorites'
    get 'products/addrating', :to => 'products#add_comments'
    get 'products/addflag', :to => 'products#add_flag'
    

    get 'product/:slug', :to => 'products#more_details'
    get 'category/:slug', :to => 'categories#products'
    get 'categories', :to => 'categories#index'
    post 'search', :to => 'searches#index'
    get 'search', :to => 'searches#index'
    get 'how-foods-are-chosen', :to => 'quality_ratings#index'
    get 'news', :to => "news_posts#index"
    get 'news/:slug', :to => 'NewsPosts#more_details'
    get 'brand/:slug', :to => 'brands#index'
    get 'page/:slug', :to => 'page#index'
    get 'faq', :to => 'faq#index'
    get 'contact-us', :to => 'page#contact'
    post 'page/contact'
    

    # end K2B Routes Code
  end

  root to: "home#index"
  

  get 'password/reset/complete', :to => 'application#password_reset'

 
  namespace :api do
    devise_for :users

    post 'password/reset', :to => 'users#reset_password'

    resources :quality_ratings
    resources :cms_texts, :only => [:index]

    resources :brands, :only => [:index, :create, :show] do
      resources :products, :only => [:index]
    end

    resources :products, :only => [:show, :create]

    post ':ratable_type/:ratable_id/ratings', :to => 'ratings#create'
    post ':flaggable_type/:flaggable_id/flags', :to => 'flag_requests#create'

    resources :categories, :only => [:index]
    resources :news_posts, :only => [:index]

    resources :users, :only => [:show, :update] do
      resources :subscriptions, :only => [:create]
    end

    get 'search', :to => 'searches#search'

    post 'feedback', :to => 'feedbacks#create'
    resources :ratings, :only => [:index, :create]
  end


  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  mount Ckeditor::Engine => "/ckeditor"
end
