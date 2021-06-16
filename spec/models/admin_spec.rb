require 'rails_helper'

RSpec.describe Admin, type: :model do
  context 'validation' do
    it 'email must end with @paynow.com.br' do
      admin = Admin.new(email: 'admin@example.com', password: '123456789')

      admin.valid?

      expect(admin.errors[:email]).to include('deve ser uma conta da PayNow')
    end
  end
end
