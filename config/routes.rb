Rails.application.routes.draw do
  resource :authentication, only: [:new, :create, :destroy]

  resources :feedbacks, only: [:new, :create]
  resources :preferences, only: :create
  resources :response_plans, only: [:index, :show]

  root to: "response_plans#index"
end
