Rails.application.routes.draw do
  resources :fashion_products, only: [:index] do
    post :search, on: :collection
  end
  root 'fashion_products#index'
end
