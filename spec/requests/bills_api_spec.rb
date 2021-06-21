require 'rails_helper'

describe 'Bills API' do
  context 'POST /api/v1/bills' do
    it 'should create a bill' do
      company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      payment_method = PaymentMethod.create!(name: 'PIX', method_type: "pix", payment_tax: 0.99, max_tax: 30, 
                                             active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
      available_payment_method = AvailablePaymentMethod.create!(company: company, payment_method: payment_method)
      product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
      customer = Customer.create!(name: 'José da Silva', cpf: CPF.generate)

      post '/api/v1/bills', params: { 
        bill: { company_token: company.id_token, payment_method_token: available_payment_method.id_token,
                product_token: product.id_token, customer_token: customer.id_token  }
      }

      expect(response).to have_http_status(201)
      expect(parsed_body['amount']).to eq("1000.0")
      expect(parsed_body['final_amount']).to eq("900.0")
      expect(parsed_body['id_token']).to eq(Bill.find(1).id_token)
    end
  end

  it 'should not create a bill with invalid params' do
    post '/api/v1/bills', params: { 
      bill: { company_token: 'Djsakdjanja', payment_method_token: 'Djsakdjanja' }
    }

    expect(response).to have_http_status(404)
    expect(response.content_type).to include('application/json')
    expect(parsed_body['errors']).to eq('paramêtros inválidos')
  end

  it 'should not create a bill with empty params' do
    post '/api/v1/customers', params: {}

    expect(response).to have_http_status(412)
    expect(response.content_type).to include('application/json')
    expect(parsed_body['errors']).to include('paramêtros inválidos')
  end

  private

  def parsed_body
    JSON.parse(response.body)
  end
end