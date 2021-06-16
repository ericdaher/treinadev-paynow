class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { common: 0, supervisor: 1 }

  validates :email, company_email: true

  belongs_to :company

  before_save do
    self.role = 'supervisor' if company.users.empty?
  end

  def active_for_authentication?
    super && self.active?
  end
  
  def inactive_message
    'Sua conta foi desativada.'
  end
end
