Rails.application.routes.draw do
  root to: "rooms#index"
  resource :session, only: %i[new create edit update destroy]

  resources :users, only: %i[index show]

  resources :rooms, only: %i[index show] do
    resources :messages, only: %i[index show] do
      resources :reactions, only: %i[create]
    end
    resources :text_messages, only: %i[create]
    resources :stamp_messages, only: %i[create]
    resources :image_messages, only: %i[create]
    resources :video_messages, only: %i[create]
    resources :reply_messages, only: %i[create]
  end

  resources :users, only: %i[] do
    resource :block, only: %i[create destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
