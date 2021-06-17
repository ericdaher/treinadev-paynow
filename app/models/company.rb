class Company < ApplicationRecord
  has_paper_trail
  
  validates :name, :email, :cnpj, presence: true
  validates :email, :cnpj, uniqueness: true
  validates :cnpj, valid_cnpj: true

  has_many :users

  def display_name
    "#{name} (@#{email_domain})"
  end

  def email_domain
    email.split('@').last
  end
end
