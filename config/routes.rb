Rails.application.routes.draw do
  devise_for :users, :controllers => { 
    :sessions => 'user/sessions',
    :registrations => 'user/registrations',
  }
  devise_for :admins, :controllers => { :registrations => 'admins/registrations' }

  root "home#index"

  resources :companies, only: [:show, :new, :create, :edit, :update]

  resources :users, only: [] do
    post 'toggle_active', on: :member, to: 'user/users#toggle_active'
  end

  namespace 'admins' do
    root "home#index"
    resources :payment_methods
  end
end
