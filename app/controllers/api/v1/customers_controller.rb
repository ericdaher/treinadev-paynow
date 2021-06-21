class Api::V1::CustomersController < Api::V1::ApiController
  before_action :set_company, only: [:create]

  def create
    @customer = Customer.new(customer_params.except(:company_token))

    if @customer.save
      render json: @customer, status: :created
      Transaction.create!(customer: @customer, company: @company)
    else
      if customer_and_company_exists?
        Transaction.create!(customer: @customer, company: @company)
        render json: @customer, status: :created
      else
        render json: @customer.errors, status: :unprocessable_entity
      end
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :cpf, :company_token)
  end

  def set_company
    @company = Company.find_by(id_token: customer_params[:company_token])
    raise ActiveRecord::RecordNotFound if @company.nil?
  end

  def customer_and_company_exists?
    if @customer.errors[:cpf] == ['já está em uso']
      @customer = Customer.find_by(cpf: @customer.cpf)
      true
    else
      false
    end
  end
end