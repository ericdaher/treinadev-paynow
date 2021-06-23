require 'rails_helper'

describe 'User views bills' do
  it 'successfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
    visa = PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    ticket = PaymentMethod.create!(name: 'Boleto', method_type: "ticket", payment_tax: 2.99, max_tax: 40, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    pix = PaymentMethod.create!(name: 'PIX', method_type: "pix", payment_tax: 0.99, max_tax: 30, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    customer = Customer.create!(name: 'José da Silva', cpf: CPF.generate)

    Bill.create!(company: company, product: product, payment_method: visa, due_date: 5.days.from_now, customer: customer)
    Bill.create!(company: company, product: product, payment_method: ticket, due_date: 6.days.from_now, customer: customer)
    Bill.create!(company: company, product: product, payment_method: pix, due_date: 7.days.from_now, customer: customer)
    
    login_as user, scope: :user
    visit root_path
    click_on 'Cobranças'

    expect(page).to have_text('Smartphone - VISA')
    expect(page).to have_text('Smartphone - Boleto')
    expect(page).to have_text('Smartphone - PIX')
    expect(page).to have_text('R$ 1.000,00')
    expect(page).to have_text('R$ 950,00')
    expect(page).to have_text('R$ 900,00')
    expect(page).to have_text('Pendente', count: 3)
  end

  it 'and view details' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
    ticket = PaymentMethod.create!(name: 'Boleto', method_type: "ticket", payment_tax: 2.99, max_tax: 40, 
                                   active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    customer = Customer.create!(name: 'José da Silva', cpf: CPF.generate)

    bill = Bill.create!(company: company, product: product, payment_method: ticket, due_date: 5.days.from_now, customer: customer)
    
    login_as user, scope: :user
    visit bills_path
    click_on 'Smartphone - Boleto'

    expect(page).to have_text('Smartphone')
    expect(page).to have_text('R$ 1.000,00')
    expect(page).to have_text('R$ 950,00')
    expect(page).to have_text('Boleto')
    expect(page).to have_text(I18n.l bill.due_date)
    expect(page).to have_text('Pendente')
    expect(page).to have_text(bill.id_token)
    expect(page).to have_text('José da Silva')
  end
end