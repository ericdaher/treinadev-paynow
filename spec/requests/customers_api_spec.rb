require 'rails_helper'

describe 'Customers API' do
  context 'POST /api/v1/customers' do
    it 'should create a customer' do
      company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      cpf = CPF.generate

      expect(Transaction.count).to eq(0)

      post '/api/v1/customers', params: { 
        customer: { name: 'José da Silva', cpf: cpf, company_token: company.id_token }
      }

      expect(response).to have_http_status(201)
      expect(parsed_body['name']).to eq('José da Silva')
      expect(parsed_body['cpf']).to eq(cpf)
      expect(parsed_body['id_token']).to eq(Customer.find(1).id_token)
      expect(Transaction.count).to eq(1)
    end

    it 'should not create a customer with no company_token' do
      cpf = CPF.generate

      post '/api/v1/customers', params: { 
        customer: { name: 'José da Silva', cpf: cpf }
      }

      expect(response).to have_http_status(404)
      expect(response.content_type).to include('application/json')
      expect(parsed_body['errors']).to eq('paramêtros inválidos')
    end

    it 'should not create a customer with invalid params' do
      company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')

      post '/api/v1/customers', params: { 
        customer: { cpf: '05151', company_token: company.id_token }
      }

      expect(response).to have_http_status(422)
      expect(response.content_type).to include('application/json')
      expect(parsed_body['name']).to include('não pode ficar em branco')
      expect(parsed_body['cpf']).to eq(['deve ser válido'])
    end

    it 'should not create a customer with empty params' do
      post '/api/v1/customers', params: {}

      expect(response).to have_http_status(412)
      expect(response.content_type).to include('application/json')
      expect(parsed_body['errors']).to include('paramêtros inválidos')
    end

    it 'should not create a new customer when adding to a new company' do
      codeplay = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      paynow = Company.create!(name: 'PayNow', cnpj: CNPJ.generate, email: 'faturamento@paynow.com.br')
      cpf = CPF.generate
      customer = Customer.create!(name: 'José da Silva', cpf: cpf)

      post '/api/v1/customers', params: { 
        customer: { name: 'José da Silva', cpf: cpf, company_token: codeplay.id_token }
      }

      expect(Transaction.count).to eq(1)

      post '/api/v1/customers', params: { 
        customer: { name: 'José da Silva', cpf: cpf, company_token: paynow.id_token }
      }

      expect(response).to have_http_status(201)
      expect(parsed_body['name']).to eq('José da Silva')
      expect(parsed_body['cpf']).to eq(cpf)
      expect(parsed_body['id_token']).to eq(customer.id_token)
      expect(Transaction.count).to eq(2)
    end
  end

  private

  def parsed_body
    JSON.parse(response.body)
  end
end