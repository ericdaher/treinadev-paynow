class Bill < ApplicationRecord
  belongs_to :product
  belongs_to :payment_method
  has_many :billing_attempts, dependent: :destroy
  has_one :company, through: :product
  has_one :receipt

  before_save :set_amount, if: :will_save_change_to_product_id?
  after_create :create_billing_attempt

  enum status: { pending: 0, approved: 1, rejected: 2, expired: 3 }

  validates :due_date, presence: true

  has_secure_token :id_token

  def final_amount
    (amount / 100) * (100 - product["discount_#{payment_method.method_type}"])
  end

  def display_name
    "#{product.name} - #{payment_method.name}"
  end

  private

  def set_amount
    self.amount = product.price
  end

  def create_billing_attempt
    BillingAttempt.create!(bill: self, status: 'pending')
  end
end
