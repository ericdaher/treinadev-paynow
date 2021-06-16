class CompaniesController < ApplicationController
  before_action :authenticate_user!, only: [:show, :edit, :update]
  before_action :set_company, only: [:show, :edit, :update]
  before_action :check_user_company, only: [:show, :edit, :update]
  before_action :check_user_role, only: [:edit, :update]

  def new
    @company = Company.new
  end

  def show
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to new_user_registration_path, notice: 'Empresa criada com sucesso'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @company.update(company_params)
      redirect_to company_path(@company), notice: 'Empresa atualizada com sucesso'
    else
      render :edit
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :cnpj, :email)
  end

  def set_company
    @company = Company.find(params[:id])
  end

  def check_user_company
    redirect_to root_path unless current_user.company == @company
  end

  def check_user_role
    redirect_to company_path, notice: 'Apenas supervisores podem editar uma empresa' unless current_user.supervisor?
  end
end