class PaymentMethod < ApplicationRecord
  has_one_attached :icon

  enum method_type: { credit_card: 0, ticket: 1, pix: 2 }

  validates :name, :method_type, :icon, :payment_tax, :max_tax, presence: true
  validates :name, uniqueness: true
  validates :payment_tax, :max_tax, numericality: { greater_than_or_equal_to: 0 }
end