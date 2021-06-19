require 'rails_helper'

describe 'User edits products' do
  it 'successfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    product = Product.create!(name: 'Videogame', price: 2000, company: company)

    login_as user, scope: :user
    visit product_path(product)
    click_on 'Editar'

    fill_in 'Nome', with: 'Smartphone'
    fill_in 'Preço', with: 1000
    fill_in 'Desconto para cartão (%)', with: 0
    fill_in 'Desconto para boleto (%)', with: 5
    fill_in 'Desconto para PIX (%)', with: 10
    click_on 'Finalizar Edição'

    expect(page).to have_text('Smartphone')
    expect(page).to have_text('R$ 1.000,00')
    expect(page).to have_text('0,0')
    expect(page).to have_text('5,0')
    expect(page).to have_text('10,0')
  end

  it "can't edit other user's product" do
    paynow = Company.create!(name: 'PayNow', cnpj: CNPJ.generate, email: 'faturamento@paynow.com.br')
    codeplay = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: codeplay)
    product = Product.create!(name: 'Smartphone', price: 1000, company: paynow, discount_credit: 0, discount_ticket: 5, discount_pix: 10)

    visit edit_product_path(product)

    expect(page).to_not have_text('Smartphone')
    expect(current_path).to eq(new_user_session_path)
  end
end