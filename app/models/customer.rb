class Customer < ApplicationRecord
  has_secure_token :id_token

  validates :name, :cpf, presence: true
  validates :cpf, uniqueness: true
  validates :cpf, valid_cpf: true

  has_many :bills
end
