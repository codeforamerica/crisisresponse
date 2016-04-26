Rails.application.routes.draw do
  namespace :admin do
    resources :people
    resources :response_strategies

    root to: "people#index"
  end

  resources :people, only: [:index, :show]
  resources :feedbacks, only: [:new, :create]
end
