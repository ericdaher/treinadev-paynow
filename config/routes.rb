Rails.application.routes.draw do
  devise_for :admins

  namespace 'admin' do
    root "home#index"
  end
end
