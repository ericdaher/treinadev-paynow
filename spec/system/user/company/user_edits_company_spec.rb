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

  it "cannot edit company if not a supervisor" do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    supervisor = User.create!(email: 'supervisor@codeplay.com.br', password: '12345678', company: company)
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)

    login_as user, scope: :user
    visit edit_company_path(company)

    expect(current_path).to eq(company_path(company))
    expect(page).to have_text('Apenas supervisores podem editar uma empresa')
  end

  it "can't edit company when not logged in" do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')

    visit edit_company_path(company)
    expect(page).to have_text('Para continuar, efetue login ou registre-se.')
    expect(current_path).to eq(new_user_session_path)
  end
end