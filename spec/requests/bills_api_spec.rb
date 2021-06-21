require 'rails_helper'

describe 'Bills API' do
  context 'POST /api/v1/bills' do
    it 'should create a bill' do

      post '/api/v1/bills', params: { 
        bill: { name: 'José da Silva', cpf: cpf, company_token: company.id_token }
      }
    end
  end

  private

  def parsed_body
    JSON.parse(response.body)
  end
end