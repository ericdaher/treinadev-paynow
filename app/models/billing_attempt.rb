class BillingAttempt < ApplicationRecord
  belongs_to :bill

  enum status: { pending: 1, approved: 5, rejected_credit: 9, rejected_data: 10, rejected_unknown: 11 }

  before_save :set_attempt_date, if: :will_save_change_to_status?
  before_save :change_bill_status, if: :will_save_change_to_status?

  private

  def set_attempt_date
    self.attempt_date = Date.today
  end

  def change_bill_status
    if status == 'approved'
      self.bill.status = 'approved'
      self.bill.save!
      create_new_receipt
    end

    if ['rejected_credit', 'rejected_data', 'rejected_unknown'].include?(status)
      create_new_billing_attempt
    end
  end

  def create_new_billing_attempt
    BillingAttempt.create!(bill: bill, status: 'pending')
  end

  def create_new_receipt
    Receipt.create!(due_date: bill.due_date, payment_date: Date.today, amount: bill.final_amount, bill: bill,
                    description: "#{bill.payment_method.name} - #{bill.product.name} - #{bill.product.company.name}")
  end
end
