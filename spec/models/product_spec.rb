require 'rails_helper'

RSpec.describe Product, type: :model do
  context 'validation' do
    it 'name, price must be present' do
      product = Product.new

      product.valid?

      expect(product.errors[:name]).to include('não pode ficar em branco')
      expect(product.errors[:price]).to include('não pode ficar em branco')
    end

    it 'price and discounts must be greater than 0' do
      product = Product.new(price: 'a', discount_ticket: -1)

      product.valid?

      expect(product.errors[:price]).to include('não é um número')
      expect(product.errors[:discount_ticket]).to include('deve ser maior ou igual a 0')
    end
  end
end
