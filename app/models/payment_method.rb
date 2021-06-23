class PaymentMethod < ApplicationRecord
  has_one_attached :icon

  enum method_type: { credit: 0, ticket: 1, pix: 2 }

  validates :name, :method_type, :icon, :payment_tax, :max_tax, presence: true
  validates :name, uniqueness: true
  validates :payment_tax, :max_tax, numericality: { greater_than_or_equal_to: 0 }
  validates :max_tax, numericality: { smaller_than: 100 }

  has_secure_token :id_token
end
