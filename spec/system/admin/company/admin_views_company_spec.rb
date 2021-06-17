require 'rails_helper'

describe 'Admin views company' do
  it 'sucessfully' do
    codeplay = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    paynow = Company.create!(name: 'PayNow', cnpj: CNPJ.generate, email: 'faturamento@paynow.com.br')
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
      
    login_as admin, scope: :admin
    visit admins_root_path
    click_on 'Empresas'

    expect(page).to have_text('CodePlay')
    expect(page).to have_text(codeplay.cnpj)
    expect(page).to have_text('faturamento@codeplay.com.br')
    expect(page).to have_text('PayNow')
    expect(page).to have_text(paynow.cnpj)
    expect(page).to have_text('faturamento@paynow.com.br')
  end

  it 'and views details' do
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    
    login_as admin, scope: :admin
    visit admins_companies_path
    click_on 'CodePlay'

    expect(page).to have_text('CodePlay')
    expect(page).to have_text(company.cnpj)
    expect(page).to have_text('faturamento@codeplay.com.br')
    expect(page).to have_text('usuario@codeplay.com.br')
  end
end