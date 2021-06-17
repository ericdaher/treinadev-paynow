require 'rails_helper'

describe 'Admin suspends company' do
  it 'successfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')

    expect(company.active).to eq(true)
      
    login_as admin, scope: :admin
    visit admins_company_path(company)
    click_on 'Suspender'

    company.reload
    expect(company.active).to eq(false)
  end

  it "and company's users are also suspended" do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)

    expect(user.active).to eq(true)

    login_as admin, scope: :admin
    visit admins_company_path(company)
    click_on 'Suspender'

    user.reload
    expect(user.active).to eq(false)
  end

  it 'and restores access' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br', active: false)
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')

    expect(company.active).to eq(false)
      
    login_as admin, scope: :admin
    visit admins_company_path(company)
    click_on 'Restaurar'

    company.reload
    expect(company.active).to eq(true)
  end

  it 'and restores users' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br', active: false)
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company, active: false)

    expect(user.active).to eq(false)
      
    login_as admin, scope: :admin
    visit admins_company_path(company)
    click_on 'Restaurar'

    user.reload
    expect(user.active).to eq(true)
  end
end