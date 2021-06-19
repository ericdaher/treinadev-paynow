class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :check_user_company, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.where(company: current_user.company)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: 'Produto criado com sucesso'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to product_path(@product), notice: 'Produto atualizado com sucesso'
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: 'Meio de pagamento removido com sucesso'
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :discount_credit, :discount_ticket, :discount_pix).merge(company: current_user.company)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def check_user_company
    redirect_to root_path unless current_user.company == @product.company
  end
end