require 'rails_helper'

describe 'User deletes products' do
  it 'successfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    product = Product.create!(name: 'Smartphone', price: 1000, company: company)

    login_as user, scope: :user
    visit product_path(product)

    expect { click_on 'Excluir'}.to change { Product.count }.by(-1)
  end
end