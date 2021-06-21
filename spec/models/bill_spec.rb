require 'rails_helper'

RSpec.describe Bill, type: :model do
  context 'validation' do
    it 'due_date must be present' do
      bill = Bill.new

      bill.valid?

      expect(bill.errors[:due_date]).to include('não pode ficar em branco')
    end
  end

  context 'billing_attempts' do
    it 'creates a pending billing_attempt after a valid bill is created' do
      company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
      ticket = PaymentMethod.create!(name: 'Boleto', method_type: "ticket", payment_tax: 2.99, max_tax: 40, 
                                   active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))

      expect(BillingAttempt.count).to eq(0)
      
      bill = Bill.create!(product: product, payment_method: ticket, due_date: 5.days.from_now)
      expect(BillingAttempt.count).to eq(1) 
      expect(bill.billing_attempts).to include(BillingAttempt.find(1))
      expect(bill.billing_attempts.first.status).to eq('pending')
    end
  end
end
