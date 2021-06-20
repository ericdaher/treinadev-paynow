class Admins::CompaniesController < Admins::AdminController 
  before_action :set_company, only: [:show, :edit, :update, :toggle_active, :regenerate_token]
  
  def index
    @companies = Company.all
  end

  def show
    @company = Company.find(params[:id])
  end

  def edit
  end

  def update
    if @company.update(company_params)
      redirect_to admins_company_path(@company), notice: 'Empresa atualizada com sucesso'
    else
      render :edit
    end
  end

  def toggle_active
    @company.active = !@company.active
    @company.save!

    @company.users.each do |user|
      user.active = @company.active 
      user.save!
    end

    redirect_to admins_company_path(@company)
  end

  def regenerate_token
    @company.regenerate_id_token
    redirect_to admins_company_path(@company), notice: 'Novo Token gerado com sucesso'
  end

  private

  def company_params
    params.require(:company).permit(:name, :cnpj, :email)
  end

  def set_company
    @company = Company.find(params[:id])
  end
end