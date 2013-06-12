HuddleUp::Application.routes.draw do

  resources :projects do
    resources :members
  end

  devise_for :users

  root :to => 'projects#index'

end
