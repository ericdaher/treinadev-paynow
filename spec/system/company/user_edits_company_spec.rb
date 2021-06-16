require 'rails_helper'

describe 'User edits company' do
  it 'sucessfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    
    login_as user, scope: :user
    visit company_path(company)
    click_on 'Editar'

    fill_in 'Razão Social', with: 'PayNow'
    click_on 'Finalizar Edição'

    expect(current_path).to eq(company_path(company))
    expect(page).to have_text('Empresa atualizada com sucesso')
  end

  it "cannot edit other user's company" do
    paynow = Company.create!(name: 'PayNow', cnpj: CNPJ.generate, email: 'faturamento@paynow.com.br')
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)

    login_as user, scope: :user
    visit edit_company_path(paynow)

    expect(current_path).to eq(root_path)
  end
end