class AvailablePaymentMethodsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company_and_payment_method, only: [:create]
  before_action :set_available_payment_method, only: [:show, :destroy]

  def index
    @available_payment_methods = AvailablePaymentMethod.all
  end

  def show
  end

  def create
    @available_payment_method = AvailablePaymentMethod.new(company: @company, payment_method: @payment_method)
    if @available_payment_method.save
      redirect_to available_payment_methods_path, notice: 'Meio de pagamento adicionado com sucesso'
    else
      render :new
    end
  end

  def destroy
    @available_payment_method.destroy
    redirect_to available_payment_methods_path, notice: 'Meio de pagamento removido com sucesso'
  end

  private

  def available_payment_method_params
    params.require(:available_payment_method).permit(:payment_method_id, :company_id)
  end

  def set_available_payment_method
    @available_payment_method = AvailablePaymentMethod.find(params[:id])
  end

  def set_company_and_payment_method
    @company = Company.find(available_payment_method_params[:company_id])
    @payment_method = PaymentMethod.find(available_payment_method_params[:payment_method_id])
  end

  def check_user_company
    @company = @available_payment_method.company if @company.nil?
    redirect_to root_path unless current_user.company == @company
  end
end