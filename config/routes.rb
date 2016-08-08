Rails.application.routes.draw do
  resource :authentication, only: [:new, :create, :destroy]

  resources :feedbacks, only: [:new, :create]
  resources :preferences, only: :create

  resources :people, only: [:index, :show]

  resources :response_plans, only: [:new, :create, :edit] do
    member { patch :approve }
  end

  root to: "response_plans#index"
end
