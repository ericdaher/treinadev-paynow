require 'rails_helper'

describe 'User views billing attempts' do
  it 'successfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
    visa = PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    customer = Customer.create!(name: 'José da Silva', cpf: CPF.generate)
    bill = Bill.create!(company: company, product: product, payment_method: visa, due_date: 5.days.from_now, customer: customer)
    billing_attempt1 = BillingAttempt.create!(bill: bill, attempt_date: 4.days.ago, status: 'rejected_unknown')
    billing_attempt2 = BillingAttempt.create!(bill: bill, attempt_date: 3.days.ago, status: 'rejected_credit')
    billing_attempt3 = BillingAttempt.create!(bill: bill, attempt_date: 2.days.ago, status: 'rejected_data')
    billing_attempt4 = BillingAttempt.create!(bill: bill, status: 'pending')
    billing_attempt5 = BillingAttempt.create!(bill: bill, attempt_date: Date.today, status: 'approved')

    login_as user, scope: :user
    visit bill_path(bill)

    expect(page).to have_text(I18n.l billing_attempt1.attempt_date)
    expect(page).to have_text(I18n.l billing_attempt2.attempt_date)
    expect(page).to have_text(I18n.l billing_attempt3.attempt_date)
    expect(page).to have_text('Cobrança não tentada')
    expect(page).to have_text(I18n.l billing_attempt5.attempt_date)
    expect(page).to have_text('Rejeitada por falta de crédito')
    expect(page).to have_text('Rejeitada por dados incorretos')
    expect(page).to have_text('Rejeitada por motivo desconhecido')
    expect(page).to have_text('Pendente')
    expect(page).to have_text('Aprovada')
  end
end