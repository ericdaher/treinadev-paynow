Rails.application.routes.draw do
  devise_for :users, :controllers => { 
    :sessions => 'user/sessions',
    :registrations => 'user/registrations',
  }
  devise_for :admins, :controllers => { :registrations => 'admins/registrations' }

  root "home#index"

  resources :companies, only: [:show, :new, :create, :edit, :update]
  resources :payment_methods, only: [:index, :show]
  resources :available_payment_methods, only: [:index, :show, :create, :destroy]

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
    end
  end
end
