Rails.application.routes.draw do
  devise_for :users, :controllers => { 
    :sessions => 'user/sessions',
    :registrations => 'user/registrations',
  }
  devise_for :admins, :controllers => { :registrations => 'admins/registrations' }

  root "home#index"

  namespace 'admins' do
    root "home#index"
  end
end
