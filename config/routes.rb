Rails.application.routes.draw do
  devise_for :officers
  namespace :admin do
    resources :response_plans
    resources :response_strategies

    root to: "response_plans#index"
  end

  resources :response_plans, only: [:index, :show]
  resources :feedbacks, only: [:new, :create]
  resources :preferences, only: :create

  root to: "response_plans#index"
end
