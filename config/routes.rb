HuddleUp::Application.routes.draw do

  resources :projects do
    resources :members
    resources :milestones
  end

  devise_for :users

  root :to => 'projects#index'

end
