# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: %i[create]
  resources :posts, only: %i[create] do
    collection do
      get 'duplicated_ips', to: 'posts#duplicated_ips'
    end
  end
  resources :ratings, only: %i[create]
end
