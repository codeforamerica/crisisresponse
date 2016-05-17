Rails.application.routes.draw do
  resources :response_plans, only: [:index, :show]
  resources :feedbacks, only: [:new, :create]
  resources :preferences, only: :create

  root to: "response_plans#index"
end
