Rails.application.routes.draw do
  devise_for :users, :controllers => { 
    :sessions => 'user/sessions',
    :registrations => 'user/registrations',
  }
  devise_for :admins, :controllers => { :registrations => 'admins/registrations' }

  root "home#index"

  resources :companies, only: [:show, :new, :create, :edit, :update]

  namespace 'admins' do
    root "home#index"
  end
end
