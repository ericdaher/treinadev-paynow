require 'rails_helper'

describe 'User registers product' do
  it 'successfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)

    login_as user, scope: :user
    visit root_path
    click_on 'Produtos'
    click_on 'Adicionar Novo'

    fill_in 'Nome', with: 'Smartphone'
    fill_in 'Preço', with: 1000
    fill_in 'Desconto para cartão (%)', with: 0
    fill_in 'Desconto para boleto (%)', with: 5
    fill_in 'Desconto para PIX (%)', with: 10
    
    expect { click_on 'Criar Produto' }.to change { Product.count }.by(1)
    expect(current_path).to eq(products_path)
    expect(page).to have_text('Produto criado com sucesso')
  end

  it "can't register when not logged in" do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)

    visit products_path
    expect(page).to_not have_text('Criar Produto')

    expect(page).to have_text('Para continuar, efetue login ou registre-se.')
    expect(current_path).to eq(new_user_session_path)
  end
end