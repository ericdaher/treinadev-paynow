require 'rails_helper'

describe 'User registers available payment method' do
  it 'successfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    PaymentMethod.create!(name: 'Boleto', method_type: "ticket", payment_tax: 2.99, max_tax: 40, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    PaymentMethod.create!(name: 'PIX', method_type: "pix", payment_tax: 0.99, max_tax: 30, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))

    login_as user, scope: :user
    visit root_path
    click_on 'Meios de Pagamento'

    expect(page).to have_text('VISA')
    expect(page).to have_text('Cartão de Crédito')
    expect(page).to have_text('Boleto')
    expect(page).to have_text('Boleto Bancário')
    expect(page).to have_text('PIX')
    expect(page).to have_text('PIX')

    click_on 'Boleto'
    click_on 'Adicionar Meio de Pagamento'

    expect(current_path).to eq(available_payment_methods_path)
    expect(page).to have_text('Meio de pagamento adicionado com sucesso')
    expect(page).to_not have_text('VISA')
    expect(page).to have_text('Boleto')
    expect(page).to_not have_text('PIX')
  end

  it "can't register inactive payment methods" do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    payment_method = PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    PaymentMethod.create!(name: 'Boleto', method_type: "ticket", payment_tax: 2.99, max_tax: 40, 
                          active: false, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))

    login_as user, scope: :user
    visit payment_methods_path
    expect(page).to have_text('VISA')
    expect(page).to have_text('Cartão de Crédito')
    expect(page).to_not have_text('Boleto')
    expect(page).to_not have_text('Boleto Bancário')
  end

  it "can't register when not logged in" do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    payment_method = PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))

    visit available_payment_methods_path
    expect(page).to_not have_text('Adicionar Meio de Pagamento')

    expect(page).to have_text('Para continuar, efetue login ou registre-se.')
    expect(current_path).to eq(new_user_session_path)
  end
end