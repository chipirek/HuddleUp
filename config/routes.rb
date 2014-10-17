HuddleUp::Application.routes.draw do

  resources :projects do
    resources :activities
    resources :members
    resources :invitations
    resources :todos
    resources :messages
    #resources :issues
    resources :issues do
      resources :comments
    end
    resources :milestones
  end

  # devise_for :users
  devise_for :users, :controllers => {:registrations => 'registrations', :sessions => 'devise/sessions'}

  root :to => 'projects#index'

  match '/users/:id', :to => 'users#show', :as => :user
  match '/projects/:project_id/issues/:issue_id/:controller/:action(/:id)'
  match '/projects/:project_id/:controller/:action(/:id)'

  get '/errors/error_404'
  get '/errors/error_500'
  get '/errors/error_422'

  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end

end
