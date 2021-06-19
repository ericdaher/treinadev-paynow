require 'rails_helper'

describe 'User views available payment method' do
  it 'successfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    visa = PaymentMethod.create!(name: 'VISA', method_type: "credit_card", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    ticket = PaymentMethod.create!(name: 'Boleto', method_type: "ticket", payment_tax: 2.99, max_tax: 40, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    pix = PaymentMethod.create!(name: 'PIX', method_type: "pix", payment_tax: 0.99, max_tax: 30, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    AvailablePaymentMethod.create!(company: company, payment_method: visa)
    AvailablePaymentMethod.create!(company: company, payment_method: ticket)
    AvailablePaymentMethod.create!(company: company, payment_method: pix)

    login_as user, scope: :user
    visit root_path
    click_on 'Meios de Pagamento'

    expect(page).to have_text('VISA')
    expect(page).to have_text('Cartão de Crédito')
    expect(page).to have_text('Boleto')
    expect(page).to have_text('Boleto Bancário')
    expect(page).to have_text('PIX')
    expect(page).to have_text('PIX')
  end

  it 'and view details' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    payment_method = PaymentMethod.create!(name: 'VISA', method_type: "credit_card", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    AvailablePaymentMethod.create!(company: company, payment_method: payment_method)

    login_as user, scope: :user
    visit available_payment_methods_path

    expect(page).to have_text('VISA')
    click_on 'VISA'

    expect(page).to have_text('VISA')
    expect(page).to have_css('img[src*="visa_logo.gif"]')
    expect(page).to have_text('Cartão de Crédito')
    expect(page).to have_text('3,99')
    expect(page).to have_text('R$ 50,00')
  end

  it "can't view when not logged in" do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    payment_method = PaymentMethod.create!(name: 'VISA', method_type: "credit_card", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    available_payment_method = AvailablePaymentMethod.create!(company: company, payment_method: payment_method)

    visit available_payment_methods_path
    expect(page).to_not have_text('VISA')

    expect(page).to have_text('Para continuar, efetue login ou registre-se.')
    expect(current_path).to eq(new_user_session_path)
  end

  it "can't view other user's available payment method" do
    paynow = Company.create!(name: 'PayNow', cnpj: CNPJ.generate, email: 'faturamento@paynow.com.br')
    codeplay = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: codeplay)
    payment_method = PaymentMethod.create!(name: 'VISA', method_type: "credit_card", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    available_payment_method = AvailablePaymentMethod.create!(company: paynow, payment_method: payment_method)

    login_as user, scope: :user
    visit available_payment_methods_path
    expect(page).to_not have_text('VISA')

    visit available_payment_method_path(available_payment_method)
    expect(page).to_not have_text('VISA')
    expect(page).to_not have_css('img[src*="visa_logo.gif"]')
    expect(page).to_not have_text('Cartão de Crédito')
    expect(page).to_not have_text('3,99')
    expect(page).to_not have_text('R$ 50,00')
  end
end