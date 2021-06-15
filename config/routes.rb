Rails.application.routes.draw do
  devise_for :admins, :controllers => { :registrations => 'admins/registrations'}

  namespace 'admin' do
    root "home#index"
  end
end
