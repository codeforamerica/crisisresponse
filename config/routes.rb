Rails.application.routes.draw do
  resource :authentication, only: [:new, :create, :destroy]

  resources :drafts, only: [:index, :show]
  resources :feedbacks, only: [:new, :create]
  resources :people, only: [:index, :show]
  resources :preferences, only: :create
  resources :response_plans, only: [:create, :edit, :update]

  resources :submissions, only: [:index, :show, :create] do
    member { patch :approve }
  end

  get "/response_plans", to: redirect("/")
  root to: "people#index"
end
