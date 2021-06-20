Rails.application.routes.draw do
  devise_for :users, :controllers => { 
    :sessions => 'user/sessions',
    :registrations => 'user/registrations',
  }
  devise_for :admins, :controllers => { :registrations => 'admins/registrations' }

  root "home#index"

  resources :companies, only: [:show, :new, :create, :edit, :update] do
    post 'regenerate_token', on: :member
  end
  resources :payment_methods, only: [:index, :show]
  resources :available_payment_methods, only: [:index, :show, :create, :destroy]
  resources :products
  resources :bills
  resources :receipts, only: [:index, :show]

  resources :users, only: [] do
    post 'toggle_active', on: :member, to: 'user/users#toggle_active'
  end

  namespace 'admins' do
    root "home#index"
    resources :payment_methods do 
      post 'toggle_active', on: :member
    end
    resources :companies, only: [:index, :show, :edit, :update] do
      post 'toggle_active', on: :member
      post 'regenerate_token', on: :member
    end
    resources :bills, only: [:index, :show]
    resources :billing_attempts, only: [] do
      post 'approve', on: :member
      post 'reject_credit', on: :member
      post 'reject_data', on: :member
      post 'reject_unknown', on: :member
    end
  end
end
