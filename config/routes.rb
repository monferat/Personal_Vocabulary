Rails.application.routes.draw do

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'

  post 'user_token' => 'user_token#create'
  mount VocabularyAPI => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'

  get 'admin' => 'control_panel#index_users', :as => :admin
  get 'admin/themes' => 'control_panel#index_themes'
  resource :control_panel, only: [:index]

  resources :users, only: [:show, :edit, :update, :destroy]
  resources :themes, only: [:create, :destroy]
  resources :words, only: [:show, :edit, :update, :destroy]

  resources :themes, only: [:index, :create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
