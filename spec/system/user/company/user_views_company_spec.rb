require 'rails_helper'

describe 'User views company' do
  it 'sucessfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    user = User.create!(email: 'usuario2@codeplay.com.br', password: '12345678', company: company)

    login_as user, scope: :user
    visit root_path
    click_on 'CodePlay'

    expect(page).to have_text('CodePlay')
    expect(page).to have_text(company.cnpj)
    expect(page).to have_text('faturamento@codeplay.com.br')
    expect(page).to have_text('usuario@codeplay.com.br')
    expect(page).to have_text('usuario2@codeplay.com.br')
    expect(page).to have_text(company.id_token)
  end

  it "can't view company when not logged in" do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')

    visit root_path
    expect(page).to_not have_text('CodePlay')

    visit company_path(company)
    expect(page).to have_text('Para continuar, efetue login ou registre-se.')
    expect(current_path).to eq(new_user_session_path)
  end

  it "can't view other user's company" do
    paynow = Company.create!(name: 'PayNow', cnpj: CNPJ.generate, email: 'faturamento@paynow.com.br')
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)

    login_as user, scope: :user
    visit company_path(paynow)

    expect(current_path).to eq(root_path)
  end
end