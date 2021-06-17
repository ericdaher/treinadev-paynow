require 'rails_helper'

describe 'User deletes available payment method' do
  it 'successfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    payment_method = PaymentMethod.create!(name: 'VISA', method_type: "credit_card", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    AvailablePaymentMethod.create!(company: company, payment_method: payment_method)

    login_as user, scope: :user
    visit available_payment_methods_path

    expect(page).to have_text('VISA')
    click_on 'VISA'
    click_on 'Excluir'

    expect(current_path).to eq(available_payment_methods_path)
    expect(page).to have_text('Meio de pagamento removido com sucesso')
    expect(page).to_not have_text('VISA')
  end
end