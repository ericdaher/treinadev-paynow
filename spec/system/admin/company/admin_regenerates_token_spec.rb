require 'rails_helper'

describe 'Admin regenerates token' do
  it 'sucessfully' do
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    old_token = company.id_token

    login_as admin, scope: :admin
    visit admins_companies_path
    click_on 'CodePlay'

    expect(page).to have_text(old_token)
    expect(page).to have_link('Gerar Novo Token')

    click_on 'Gerar Novo Token'

    company.reload
    new_token = company.id_token
    expect(page).to_not have_text(old_token)
    expect(page).to have_text(new_token)
    expect(page).to have_text('Novo Token gerado com sucesso')
  end
end