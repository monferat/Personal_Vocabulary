Rails.application.routes.draw do

  get 'admin' => 'control_panel#index_users', :as => :admin
  get 'admin/themes' => 'control_panel#index_themes'
  resource :control_panel, only: [:index]

  get 'sessions/new'
  get 'welcome/index'

  root 'welcome#index'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users
  resources :themes, only: [:create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
