class User::UsersController < ApplicationController
  before_action :authenticate_user!
  
  def toggle_active
    user = User.find(params[:id])
    return unless current_user.supervisor? && current_user.company == user.company

    user.active = !user.active
    user.save!
  end
end