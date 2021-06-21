require 'rails_helper'

describe 'User deletes bills' do
  it 'successfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
    ticket = PaymentMethod.create!(name: 'Boleto', method_type: "ticket", payment_tax: 2.99, max_tax: 40, 
                                   active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    customer = Customer.create!(name: 'José da Silva', cpf: CPF.generate)

    bill = Bill.create!(product: product, payment_method: ticket, due_date: 5.days.from_now, customer: customer)

    login_as user, scope: :user
    visit bill_path(bill)
    
    expect { click_on('Excluir') }.to change { Bill.count }.by(-1)
    expect(current_path).to eq(bills_path)
    expect(page).to have_text('Cobrança removida com sucesso')
  end
end