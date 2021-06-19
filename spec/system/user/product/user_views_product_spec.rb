require 'rails_helper'

describe 'User views products' do
  it 'successfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    Product.create!(name: 'Smartphone', price: 1000, company: company)
    Product.create!(name: 'Videogame', price: 2000, company: company)
    Product.create!(name: 'Televisão', price: 1500, company: company)

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
    Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)

    login_as user, scope: :user
    visit products_path
    click_on 'Smartphone'

    expect(page).to have_text('Smartphone')
    expect(page).to have_text('R$ 1.000,00')
    expect(page).to have_text('0,0')
    expect(page).to have_text('5,0')
    expect(page).to have_text('10,0')
  end

  it "can't view when not logged in" do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)

    visit products_path

    expect(page).to have_text('Para continuar, efetue login ou registre-se.')
    expect(current_path).to eq(new_user_session_path)
  end

  it "can't view other user's products" do
    paynow = Company.create!(name: 'PayNow', cnpj: CNPJ.generate, email: 'faturamento@paynow.com.br')
    codeplay = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: codeplay)
    product = Product.create!(name: 'Smartphone', price: 1000, company: paynow, discount_credit: 0, discount_ticket: 5, discount_pix: 10)

    login_as user, scope: :user
    visit products_path
    expect(page).to_not have_text('Smartphone')

    visit product_path(product)
    expect(page).to_not have_text('Smartphone')
    expect(page).to_not have_text('R$ 1.000,00')
    expect(page).to_not have_text('0,0')
    expect(page).to_not have_text('5,0')
    expect(page).to_not have_text('10,0')
  end
end