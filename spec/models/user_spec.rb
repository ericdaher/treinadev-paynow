require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validation' do
    it 'email domain must be the same as the company' do
      company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      user = User.new(email: 'usuario@codeplay.com', password: '12345678', company: company)

      user.valid?

      expect(user.errors[:email]).to include('deve ter o mesmo domínio do email da empresa')
    end
  end
end
