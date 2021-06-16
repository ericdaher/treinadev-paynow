require 'rails_helper'

RSpec.describe Company, type: :model do
  context 'validation' do
    it 'name, email and cnpj must be present' do
      company = Company.new

      company.valid?

      expect(company.errors[:name]).to include('não pode ficar em branco')
      expect(company.errors[:cnpj]).to include('não pode ficar em branco')
      expect(company.errors[:email]).to include('não pode ficar em branco')
    end

    it 'email must be unique' do
      Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      company = Company.new(name: 'PayNow', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      
      company.valid?

      expect(company.errors[:email]).to include('já está em uso')
    end

    it 'cnpj must be unique' do
      cnpj = CNPJ.generate

      Company.create!(name: 'CodePlay', cnpj: cnpj, email: 'faturamento@codeplay.com.br')
      company = Company.new(name: 'PayNow', cnpj: cnpj, email: 'faturamento@paynow.com.br')
      
      company.valid?

      expect(company.errors[:cnpj]).to include('já está em uso')
    end

    it 'cnpj must be valid' do
      company = Company.new(name: 'CodePlay', cnpj: "01.234.567/8910-11", email: 'faturamento@codeplay.com.br')

      company.valid?

      expect(company.errors[:cnpj]).to include('deve ser válido')
    end
  end
end
