Rails.application.routes.draw do
  resources :user_rate_limiters, only: [] do
    member do
      get 'consume_api'
    end
  end
  root 'user_rate_limiters#index'
end
