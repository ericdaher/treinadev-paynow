require 'rails_helper'

describe 'User views products' do
  it 'successfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    Product.create!(name: 'Smartphone', value: 1000, company: company)
    Product.create!(name: 'Videogame', value: 2000, company: company)
    Product.create!(name: 'Televisão', value: 1500, company: company)

    login_as user, scope: :user
    visit root_path

    click_on 'Produtos'

    expect(page).to have_text('Smartphone')
    expect(page).to have_text('R$ 1.000,00')
    expect(page).to have_text('Videogame')
    expect(page).to have_text('R$ 2.000,00')
    expect(page).to have_text('Televisão')
    expect(page).to have_text('R$ 1.500,00')
  end

  it 'and view details' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    Product.create!(name: 'Smartphone', value: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)

    login_as user, scope: :user
    visit products_path
    click_on 'Smartphone'

    expect(page).to have_text('Smartphone')
    expect(page).to have_text('R$ 1.000,00')
    expect(page).to have_text('0,0')
    expect(page).to have_text('5,0')
    expect(page).to have_text('10,0')
  end
end