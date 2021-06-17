require 'rails_helper'

describe 'Admin edits company' do
  it 'sucessfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
      
    login_as admin, scope: :admin
    visit admins_company_path(company)
    click_on 'Editar'

    fill_in 'Razão Social', with: 'PayNow'
    click_on 'Finalizar Edição'

    expect(current_path).to eq(admins_company_path(company))
    expect(page).to have_text('Empresa atualizada com sucesso')
  end
end