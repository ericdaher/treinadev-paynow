require 'rails_helper'

describe 'Bills API' do
  context 'GET /api/v1/bills' do
    it 'should respond with all bills' do
      company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
      visa = PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                            active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
      ticket = PaymentMethod.create!(name: 'Boleto', method_type: "ticket", payment_tax: 2.99, max_tax: 40, 
                            active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
      pix = PaymentMethod.create!(name: 'PIX', method_type: "pix", payment_tax: 0.99, max_tax: 30, 
                            active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
      customer = Customer.create!(name: 'José da Silva', cpf: CPF.generate)
  
      Bill.create!(company: company, product: product, payment_method: visa, due_date: 5.days.from_now, customer: customer)
      Bill.create!(company: company, product: product, payment_method: ticket, due_date: 6.days.from_now, customer: customer)
      Bill.create!(company: company, product: product, payment_method: pix, due_date: 7.days.from_now, customer: customer)
      
      get '/api/v1/bills', params: { 
        bill: { company_token: company.id_token  }
      }

      expect(response).to have_http_status(200)
      expect(parsed_body.length).to eq(3)
    end

    it 'should filter bills by payment_method' do
      company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
      visa = PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                            active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
      ticket = PaymentMethod.create!(name: 'Boleto', method_type: "ticket", payment_tax: 2.99, max_tax: 40, 
                            active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
      pix = PaymentMethod.create!(name: 'PIX', method_type: "pix", payment_tax: 0.99, max_tax: 30, 
                            active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
      customer = Customer.create!(name: 'José da Silva', cpf: CPF.generate)
  
      Bill.create!(company: company, product: product, payment_method: visa, due_date: 5.days.from_now, customer: customer)
      Bill.create!(company: company, product: product, payment_method: ticket, due_date: 6.days.from_now, customer: customer)
      Bill.create!(company: company, product: product, payment_method: pix, due_date: 7.days.from_now, customer: customer)

      get '/api/v1/bills', params: { 
        bill: { company_token: company.id_token, payment_method_token: visa.id_token  }
      }

      expect(response).to have_http_status(200)
      expect(parsed_body.length).to eq(1)
    end

    it 'should filter bills by due_date' do
      company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
      visa = PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                            active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
      ticket = PaymentMethod.create!(name: 'Boleto', method_type: "ticket", payment_tax: 2.99, max_tax: 40, 
                            active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
      pix = PaymentMethod.create!(name: 'PIX', method_type: "pix", payment_tax: 0.99, max_tax: 30, 
                            active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
      customer = Customer.create!(name: 'José da Silva', cpf: CPF.generate)
  
      Bill.create!(company: company, product: product, payment_method: visa, due_date: 5.days.from_now, customer: customer)
      Bill.create!(company: company, product: product, payment_method: ticket, due_date: 6.days.from_now, customer: customer)
      Bill.create!(company: company, product: product, payment_method: pix, due_date: 7.days.from_now, customer: customer)

      get '/api/v1/bills', params: { 
        bill: { company_token: company.id_token, due_date: (I18n.l (Date.tomorrow + 5.days)) }
      }

      expect(response).to have_http_status(200)
      expect(parsed_body.length).to eq(1)
    end

    it 'should filter bills by payment_method and due_date' do
      company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
      visa = PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                            active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
      ticket = PaymentMethod.create!(name: 'Boleto', method_type: "ticket", payment_tax: 2.99, max_tax: 40, 
                            active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
      pix = PaymentMethod.create!(name: 'PIX', method_type: "pix", payment_tax: 0.99, max_tax: 30, 
                            active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
      customer = Customer.create!(name: 'José da Silva', cpf: CPF.generate)

      Bill.create!(company: company, product: product, payment_method: visa, due_date: 5.days.from_now, customer: customer)
      Bill.create!(company: company, product: product, payment_method: visa, due_date: 6.days.from_now, customer: customer)
      Bill.create!(company: company, product: product, payment_method: ticket, due_date: 6.days.from_now, customer: customer)
      Bill.create!(company: company, product: product, payment_method: pix, due_date: 7.days.from_now, customer: customer)

      get '/api/v1/bills', params: { 
        bill: { company_token: company.id_token, payment_method_token: visa.id_token, due_date: (I18n.l (Date.tomorrow + 5.days))  }
      }

      expect(response).to have_http_status(200)
      expect(parsed_body.length).to eq(1)
    end
  end

  context 'POST /api/v1/bills' do
    it 'should create a bill' do
      company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      payment_method = PaymentMethod.create!(name: 'PIX', method_type: "pix", payment_tax: 0.99, max_tax: 30, 
                                             active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
      product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
      customer = Customer.create!(name: 'José da Silva', cpf: CPF.generate)

      post '/api/v1/bills', params: { 
        bill: { company_token: company.id_token, payment_method_token: payment_method.id_token,
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