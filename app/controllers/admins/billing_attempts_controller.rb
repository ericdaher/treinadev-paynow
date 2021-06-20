class Admins::BillingAttemptsController < Admins::AdminController
  before_action :set_billing_attempt

  def approve
    @billing_attempt.status = 'approved'
    if @billing_attempt.save!
      redirect_to admins_bill_path(@billing_attempt.bill)
    end
  end

  def reject_credit
    @billing_attempt.status = 'rejected_credit'
    if @billing_attempt.save!
      redirect_to admins_bill_path(@billing_attempt.bill)
    end
  end

  def reject_data
    @billing_attempt.status = 'rejected_data'
    if @billing_attempt.save!
      redirect_to admins_bill_path(@billing_attempt.bill)
    end
  end

  def reject_unknown
    @billing_attempt.status = 'rejected_unknown'
    if @billing_attempt.save!
      redirect_to admins_bill_path(@billing_attempt.bill)
    end
  end

  private

  def set_billing_attempt
    @billing_attempt = BillingAttempt.find(params[:id])
  end
end