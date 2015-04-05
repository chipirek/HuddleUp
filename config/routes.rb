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

  #--- newer, more explicit routes in Rails 4
  put '/projects/:project_id/todos/mark_complete/:id' => 'todos#mark_complete'
  put '/projects/:project_id/todos/mark_incomplete/:id' => 'todos#mark_incomplete'
  post '/projects/:project_id/todos/sort' => 'todos#sort'
  put '/projects/:project_id/issues/mark_complete/:id' => 'issues#mark_complete'
  put '/projects/:project_id/issues/mark_incomplete/:id' => 'issues#mark_incomplete'
  post '/projects/:project_id/issues/sort' => 'issues#sort'

  put '/projects/:project_id/members/make_admin/:id' => 'members#make_admin'
  put '/projects/:project_id/members/remove_admin/:id' => 'members#remove_admin'
  put '/projects/:project_id/members/block/:id' => 'members#block'
  put '/projects/:project_id/members/unblock/:id' => 'members#unblock'

end
