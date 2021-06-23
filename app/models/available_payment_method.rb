class AvailablePaymentMethod < ApplicationRecord
  belongs_to :payment_method
  belongs_to :company

  validates :payment_method, uniqueness: { scope: :company }
end
