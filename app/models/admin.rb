class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, format: { with: /\b[A-Z0-9._%a-z\-]+@paynow\.com\.br\z/, message: 'deve ser uma conta da PayNow' }
end
