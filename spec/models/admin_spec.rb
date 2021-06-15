require 'rails_helper'

RSpec.describe Admin, type: :model do
  it 'email must be unique' do
    Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    admin = Admin.new(email: 'admin@paynow.com.br', password: '123456789')

    admin.valid?

    expect(admin.errors[:email]).to include('já está em uso')
  end

  it 'email must end with @paynow.com.br' do
    admin = Admin.new(email: 'admin@example.com', password: '123456789')

    admin.valid?

    expect(admin.errors[:email]).to include('deve ser uma conta da PayNow')
  end
end
