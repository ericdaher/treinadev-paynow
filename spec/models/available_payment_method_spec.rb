require 'rails_helper'

RSpec.describe AvailablePaymentMethod, type: :model do
  context 'validation' do
    it 'company and payment_method must be present' do
      available_payment_method = AvailablePaymentMethod.new

      available_payment_method.valid?

      expect(available_payment_method.errors[:company]).to include('é obrigatório(a)')
      expect(available_payment_method.errors[:payment_method]).to include('é obrigatório(a)')
    end

    it 'company and payment_method must be unique' do
      company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      payment_method = PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
      AvailablePaymentMethod.create!(company: company, payment_method: payment_method)
      available_payment_method = AvailablePaymentMethod.new(company: company, payment_method: payment_method)

      available_payment_method.valid?

      expect(available_payment_method.errors[:payment_method]).to include('já está em uso')
    end
  end
end
