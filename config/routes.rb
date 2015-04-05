HuddleUp::Application.routes.draw do

  get 'home/index'
  get '/errors/error_404'
  get '/errors/error_500'
  get '/errors/error_422'

  mount StripeEvent::Engine => '/stripe'

  resources :projects do
    resources :activities
    resources :categories
    resources :members
    resources :invitations
    resources :todos do
      get 'planner', on: :collection
      post 'set_due_date'
    end
    resources :announcements
    resources :issues do
      resources :comments
    end
    resources :events
    get 'settings', :to => 'projects#get_settings', :controller => 'projects'
    post 'set_settings', :to => 'projects#set_settings', :controller => 'projects'
  end

  # devise_for :users
  devise_for :users, :controllers => {:registrations => 'registrations', :sessions => 'devise/sessions'}
  devise_scope :user do
    put 'update_card', :to => 'registrations#update_card', as: :update_card
  end

  unauthenticated do
    root to: 'home#index', as: :unauthenticated_root
  end

  authenticated :user do
    root to: 'projects#index', as: :authenticated_root
  end


  #match '/users/:id', :to => 'users#show', :as => :user
  #match '/users/billing', :to => 'registrations#show', :as => :user
  #match '/projects/:project_id/:controller/:action(/:id)'
  get '/users/:id', :to => 'users#show', :as => :user_id
  get '/users/billing', :to => 'registrations#show', :as => :user_billing
  #get '/projects/:project_id/:controller/:action(/:id)'

  unless Rails.application.config.consider_all_requests_local
    #match '*not_found', to: 'errors#error_404'
    get '*not_found', to: 'errors#error_404'
  end

end
