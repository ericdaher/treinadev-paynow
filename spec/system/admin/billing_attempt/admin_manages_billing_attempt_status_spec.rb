require 'rails_helper'

describe 'Admin manages billing attempts status' do
  it 'approves billing attempt' do
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
    visa = PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    customer = Customer.create!(name: 'José da Silva', cpf: CPF.generate)
    bill = Bill.create!(company: company, product: product, payment_method: visa, due_date: 5.days.from_now, customer: customer)

    login_as admin, scope: :admin
    visit admins_bill_path(bill)

    expect(page).to have_text('Cobrança não tentada')
    expect(page).to have_text('Pendente', count: 2)
    expect(page).to have_link('Aprovar (05)')

    click_on 'Aprovar (05)'

    expect(page).to_not have_text('Pendente')
    expect(page).to have_text('Aprovada', count: 2)
    expect(page).to have_text(I18n.l Date.today)
  end

  it 'rejects biling attempt because of credit' do
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
    visa = PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    customer = Customer.create!(name: 'José da Silva', cpf: CPF.generate)
    bill = Bill.create!(company: company, product: product, payment_method: visa, due_date: 5.days.from_now, customer: customer)

    login_as admin, scope: :admin
    visit admins_bill_path(bill)

    expect(page).to have_text('Cobrança não tentada')
    expect(page).to have_text('Pendente', count: 2)
    expect(page).to have_link('Rejeitar - Crédito (09)')

    expect { click_on 'Rejeitar - Crédito (09)' }.to change { BillingAttempt.count }.by(1)

    expect(page).to have_text('Cobrança não tentada')
    expect(page).to have_text('Pendente', count: 2)
    expect(page).to have_text('Rejeitada por falta de crédito (09)')
    expect(page).to have_text(I18n.l Date.today)
  end

  it 'rejects biling attempt because of data' do
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
    visa = PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    customer = Customer.create!(name: 'José da Silva', cpf: CPF.generate)
    bill = Bill.create!(company: company, product: product, payment_method: visa, due_date: 5.days.from_now, customer: customer)

    login_as admin, scope: :admin
    visit admins_bill_path(bill)

    expect(page).to have_text('Cobrança não tentada')
    expect(page).to have_text('Pendente', count: 2)
    expect(page).to have_link('Rejeitar - Dados (10)')

    expect { click_on 'Rejeitar - Dados (10)' }.to change { BillingAttempt.count }.by(1)

    expect(page).to have_text('Cobrança não tentada')
    expect(page).to have_text('Pendente', count: 2)
    expect(page).to have_text('Rejeitada por dados incorretos (10)')
    expect(page).to have_text(I18n.l Date.today)
  end

  it 'rejects biling attempt because of unknown reason' do
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
    visa = PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    customer = Customer.create!(name: 'José da Silva', cpf: CPF.generate)
    bill = Bill.create!(company: company, product: product, payment_method: visa, due_date: 5.days.from_now, customer: customer)

    login_as admin, scope: :admin
    visit admins_bill_path(bill)

    expect(page).to have_text('Cobrança não tentada')
    expect(page).to have_text('Pendente', count: 2)
    expect(page).to have_link('Rejeitar - Desconhecido (11)')

    expect { click_on 'Rejeitar - Desconhecido (11)' }.to change { BillingAttempt.count }.by(1)

    expect(page).to have_text('Cobrança não tentada')
    expect(page).to have_text('Pendente', count: 2)
    expect(page).to have_text('Rejeitada por motivo desconhecido (11)')
    expect(page).to have_text(I18n.l Date.today)
  end
end