class BillsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bill, only: [:show, :edit, :update, :destroy]

  def index
    @bills = Bill.all
  end

  def show
  end

  def new
    @products = Product.where(company: current_user.company)
    @payment_methods = AvailablePaymentMethod.where(company: current_user.company).map(&:payment_method)
    @bill = Bill.new
  end

  def create
    @bill = Bill.new(bill_params)
    if @bill.save
      redirect_to bills_path, notice: 'Cobrança criada com sucesso'
    else
      render :new
    end
  end

  def edit
    @products = Product.where(company: current_user.company)
    @payment_methods = AvailablePaymentMethod.where(company: current_user.company).map(&:payment_method)
  end

  def update
    if @bill.update(bill_params)
      redirect_to bill_path(@bill), notice: 'Cobrança atualizada com sucesso'
    else
      render :edit
    end
  end

  def destroy
    @bill.destroy
    redirect_to bills_path, notice: 'Cobrança removida com sucesso'
  end

  private

  def bill_params
    params.require(:bill).permit(:product_id, :payment_method_id, :due_date)
  end

  def set_bill
    @bill = Bill.find(params[:id])
  end
end