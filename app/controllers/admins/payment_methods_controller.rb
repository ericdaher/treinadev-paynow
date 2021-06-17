class Admins::PaymentMethodsController < Admins::AdminController
  before_action :set_payment_method, only: [:show, :edit, :update, :destroy]

  def index
    @payment_methods = PaymentMethod.all
  end
  
  def show
  end

  def new
    @payment_method = PaymentMethod.new
  end

  def create
    @payment_method = PaymentMethod.new(payment_method_params)
    if @payment_method.save
      redirect_to admins_payment_methods_path, notice: 'Meio de pagamento criado com sucesso'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @payment_method.update(payment_method_params)
      redirect_to admins_payment_methods_path(@payment_method), notice: 'Meio de pagamento atualizado com sucesso'
    else
      render :edit
    end
  end

  def destroy
    @payment_method.destroy
    redirect_to admins_payment_methods_path, notice: 'Meio de pagamento excluído com sucesso'
  end

  private

  def payment_method_params
    params.require(:payment_method).permit(:name, :method_type, :max_tax, :payment_tax, :icon)
  end

  def set_payment_method
    @payment_method = PaymentMethod.find(params[:id])
  end
end