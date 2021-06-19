require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  context 'validation' do
    it 'name, icon, payment_tax and max_tax must be present' do
      payment_method = PaymentMethod.new

      payment_method.valid?

      expect(payment_method.errors[:name]).to include('não pode ficar em branco')
      expect(payment_method.errors[:icon]).to include('não pode ficar em branco')
      expect(payment_method.errors[:payment_tax]).to include('não pode ficar em branco')
      expect(payment_method.errors[:max_tax]).to include('não pode ficar em branco')
    end

    it 'name must be unique' do
      PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                            active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
      payment_method = PaymentMethod.new(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                            active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))

      payment_method.valid?

      expect(payment_method.errors[:name]).to include('já está em uso')                   
    end

    it 'payment_tax and max_tax must be numeric and greater than 0' do
      payment_method = PaymentMethod.new(name: 'VISA', method_type: "credit", payment_tax: 'a', max_tax: -1, 
                                         active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
      
      payment_method.valid?

      expect(payment_method.errors[:payment_tax]).to include('não é um número')
      expect(payment_method.errors[:max_tax]).to include('deve ser maior ou igual a 0')
    end
  end
end
