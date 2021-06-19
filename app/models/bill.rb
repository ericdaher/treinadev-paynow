class Bill < ApplicationRecord
  belongs_to :product
  belongs_to :payment_method

  before_save :set_amount

  enum status: { pending: 0, approved: 1, rejected: 2, expired: 3 }

  def final_amount
    (amount / 100) * (100 - product["discount_#{payment_method.method_type}"])
  end

  def set_amount
    self.amount = product.price
  end
end
