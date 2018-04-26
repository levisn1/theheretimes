Rails.application.routes.draw do

  resources :bookmarks

  resources :articles, only: [:index, :show]

  devise_for :users
  root to: 'pages#home'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :articles, only: [ :index ]
    end
  end
end
