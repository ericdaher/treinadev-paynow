class AvailablePaymentMethod < ApplicationRecord
  belongs_to :payment_method
  belongs_to :company

  validates :payment_method, uniqueness: { scope: :company }

  has_secure_token :id_token
end
