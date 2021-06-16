require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validation' do
    it 'email domain must be the same as the company' do
      company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      user = User.new(email: 'usuario@codeplay.com', password: '12345678', company: company)

      user.valid?

      expect(user.errors[:email]).to include('deve ter o mesmo domínio do email da empresa')
    end

    it 'first user must be declared company supervisor' do
      company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      supervisor = User.create!(email: 'supervisor@codeplay.com.br', password: '12345678', company: company)
      common = User.create!(email: 'comum@codeplay.com.br', password: '12345678', company: company)

      expect(supervisor.role).to eq("supervisor")
      expect(common.role).to eq("common")
    end
  end
end
