Rails.application.routes.draw do
  resources :fashion_products, only: [:index]
  root 'fashion_products#index'
end
