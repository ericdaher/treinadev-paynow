require 'rails_helper'

describe 'Visitor views receipt' do
  it 'successfuly' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
    ticket = PaymentMethod.create!(name: 'Boleto', method_type: "ticket", payment_tax: 2.99, max_tax: 40, 
                                   active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    customer = Customer.create!(name: 'José da Silva', cpf: CPF.generate)                               
    bill = Bill.create!(product: product, payment_method: ticket, due_date: 5.days.from_now, customer: customer)
    receipt = Receipt.create!(due_date: bill.due_date, payment_date: Date.today, amount: bill.final_amount, bill: bill,
                    description: "#{bill.payment_method.name} - #{bill.product.name} - #{bill.product.company.name}")

    visit root_path
    click_on 'Consultar Recibo'

    fill_in 'Número do Recibo', with: 1
    click_on 'Consultar'

    expect(page).to have_text('Boleto - Smartphone - CodePlay')
  end
end