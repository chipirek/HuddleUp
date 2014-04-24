HuddleUp::Application.routes.draw do

  resources :messages


  resources :projects do
    resources :activities
    resources :members
    resources :invitations
    resources :todos
    resources :messages
    resources :issues
    #resources :issues do
    #  resources :posts
    #  resources :action_items
    #end
    resources :milestones
  end

  #devise_for :users
  devise_for :users, :controllers => {:registrations => 'registrations'}

  root :to => 'projects#index'

  match '/projects/:project_id/issues/:issue_id/:controller/:action(/:id)'
  match '/projects/:project_id/:controller/:action(/:id)'
  #match ':controller(/:action(/:id(.:format)))'
  #match '/projects/:project_id/milestones/:milestone_id/:controller/:action' #sort
end
