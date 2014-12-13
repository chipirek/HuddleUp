HuddleUp::Application.routes.draw do

  get 'home/index'
  get '/errors/error_404'
  get '/errors/error_500'
  get '/errors/error_422'

  mount StripeEvent::Engine => '/stripe'

  resources :projects do
    resources :activities
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
  end

  # devise_for :users
  devise_for :users, :controllers => {:registrations => 'registrations', :sessions => 'devise/sessions'}
  devise_scope :user do
    put 'update_card', :to => 'registrations#update_card'
  end

  #root :to => 'projects#index'
  #root :to => 'home#index'
  unauthenticated do
    root to: 'home#index'
  end

  authenticated :user do
    root to: 'projects#index'
  end


  #match '/projects/:project_id/todos/:action',
  match '/users/:id', :to => 'users#show', :as => :user
  match '/users/billing', :to => 'registrations#show', :as => :user
  #match '/projects/:project_id/issues/:issue_id/:controller/:action(/:id)'
  match '/projects/:project_id/:controller/:action(/:id)'

  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end

end
