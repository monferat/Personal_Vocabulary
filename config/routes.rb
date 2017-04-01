Rails.application.routes.draw do

  post 'user_token' => 'user_token#create'
  mount VocabularyAPI => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'

  get 'admin' => 'control_panel#index_users', :as => :admin
  get 'admin/themes' => 'control_panel#index_themes'
  resource :control_panel, only: [:index]
=begin
  get 'sessions/new'
  get 'welcome/index'
=end
#  root 'welcome#index'
=begin
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    collection do
      get 'check'
    end
  end
=end
  resources :users, only: [:show, :edit, :update, :destroy]
  resources :themes, only: [:create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
