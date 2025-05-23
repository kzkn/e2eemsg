Rails.application.routes.draw do
  root to: "rooms#index"
  resource :session, only: %i[new create destroy]
  resources :rooms, only: %i[index show] do
    resources :messages, only: %i[index show]
    resources :text_messages, only: %i[create]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
