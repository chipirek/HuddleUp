HuddleUp::Application.routes.draw do

  resources :projects do
    resources :members
    resources :milestones do
      resources :tasks
    end
    resources :todos
  end

  devise_for :users

  root :to => 'projects#index'

  #match ':controller(/:action(/:id(.:format)))'
  match '/projects/:project_id/:controller/:action(/:id)'
  match '/projects/:project_id/milestones/:milestone_id/:controller/:action(/:id)'
end
