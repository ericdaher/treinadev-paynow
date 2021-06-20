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
    end

    if ['rejected_credit', 'rejected_data', 'rejected_unknown'].include?(status)
      create_new_billing_attempt
    end
  end

  def create_new_billing_attempt
    BillingAttempt.create!(bill: self.bill, status: 'pending')
  end
end
