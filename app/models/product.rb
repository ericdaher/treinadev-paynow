class Product < ApplicationRecord
  belongs_to :company

  validates :name, :price, presence: true
  validates :price, :discount_credit, :discount_ticket, :discount_pix, numericality: { greater_than_or_equal_to: 0 }

  has_secure_token :id_token
end
