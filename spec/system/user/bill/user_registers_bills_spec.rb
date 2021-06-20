require 'rails_helper'

describe 'User register bills' do
  it 'successfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
    visa = PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    AvailablePaymentMethod.create!(company: company, payment_method: visa)

    login_as user, scope: :user
    visit bills_path
    click_on 'Adicionar Cobrança'

    select 'Smartphone', from: 'Produto'
    select 'VISA', from: 'Meios de Pagamento'
    fill_in 'Data limite de pagamento', with: 5.days.from_now
    click_on 'Criar Cobrança'

    expect(current_path).to eq(bills_path)
    expect(page).to have_text('Cobrança criada com sucesso')
    expect(page).to have_text('Smartphone - VISA')
    expect(page).to have_text('R$ 1.000,00')
    expect(page).to have_text('Pendente')
  end
end