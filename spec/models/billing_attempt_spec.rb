require 'rails_helper'

RSpec.describe BillingAttempt, type: :model do
  context 'validation' do
  end

  context 'receipts' do
    it 'creates a receipt when status changes to approved' do
      company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
      ticket = PaymentMethod.create!(name: 'Boleto', method_type: "ticket", payment_tax: 2.99, max_tax: 40, 
                                  active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
      customer = Customer.create!(name: 'José da Silva', cpf: CPF.generate)
                            
      bill = Bill.create!(product: product, payment_method: ticket, due_date: 5.days.from_now, customer: customer)
      billing_attempt = bill.billing_attempts.first

      expect(Receipt.count).to eq(0) 

      billing_attempt.status = 'approved'
      billing_attempt.save!

      expect(Receipt.count).to eq(1)
      expect(bill.receipt).to eq(Receipt.find(1))
    end
  end
end