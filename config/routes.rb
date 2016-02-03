Rails.application.routes.draw do
  resources :people, only: [:index, :show]

  get "latest", to: "people#latest"
end
