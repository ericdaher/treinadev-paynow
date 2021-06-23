class Api::V1::BillsController < Api::V1::ApiController
  before_action :set_company, only: [:index, :create]
  before_action :set_payment_method, only: [:create]
  before_action :set_product, only: [:create]
  before_action :set_customer, only: [:create]

  def index
    @bills = Bill.where(company: @company)

    set_payment_method if bill_params.include?(:payment_method_token)
    @bills = @bills.where(payment_method: @payment_method) unless @payment_method.nil?
    @bills = @bills.where(due_date: bill_params[:due_date].to_date) if bill_params.include?(:due_date)

    render json: @bills.as_json(except: [:id, :created_at, :updated_at, :product_id, :company_id, :customer_id, :payment_method_id, :receipt_id]), status: 200
  end

  def create
    @bill = Bill.new(company: @company, payment_method: @payment_method, product: @product, due_date: 1.day.from_now, customer: @customer)

    if @bill.save
      render json: @bill.as_json.merge(final_amount: @bill.final_amount), status: :created
    else
      render json: @bill.errors, status: :unprocessable_entity
    end
  end

  private

  def bill_params
    params.require(:bill).permit(:company_token, :payment_method_token, :product_token, :customer_token, :due_date)
  end

  def set_company
    @company = Company.find_by(id_token: bill_params[:company_token])
    raise ActiveRecord::RecordNotFound if @company.nil?
  end

  def set_payment_method
    @payment_method = PaymentMethod.find_by(id_token: bill_params[:payment_method_token])
    raise ActiveRecord::RecordNotFound if @payment_method.nil?
  end

  def set_product
    @product = @company.products.find_by(id_token: bill_params[:product_token])
    raise ActiveRecord::RecordNotFound if @product.nil?
  end

  def set_customer
    @customer = Customer.find_by(id_token: bill_params[:customer_token])
    raise ActiveRecord::RecordNotFound if @customer.nil?
  end
end