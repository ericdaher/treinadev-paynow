require 'rails_helper'

describe 'User edits bills' do
  it 'successfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    product = Product.create!(name: 'Smartphone', price: 1000, company: company, discount_credit: 0, discount_ticket: 5, discount_pix: 10)
    Product.create!(name: 'Videogame', price: 2000, company: company)
    visa = PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                                 active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    ticket = PaymentMethod.create!(name: 'Boleto', method_type: "ticket", payment_tax: 2.99, max_tax: 40, 
                                   active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    AvailablePaymentMethod.create!(company: company, payment_method: visa)
    AvailablePaymentMethod.create!(company: company, payment_method: ticket)
    customer = Customer.create!(name: 'José da Silva', cpf: CPF.generate)

    bill = Bill.create!(product: product, payment_method: ticket, due_date: 5.days.from_now, customer: customer)
    
    login_as user, scope: :user
    visit bill_path(bill)
    click_on 'Editar'

    select 'Videogame', from: 'Produto'
    select 'VISA', from: 'Meios de Pagamento'
    fill_in 'Data limite de pagamento', with: 10.days.from_now
    click_on 'Finalizar Edição'

    expect(page).to have_text('Videogame')
    expect(page).to have_text('R$ 2.000,00')
    expect(page).to have_text('R$ 2.000,00')
    expect(page).to have_text('VISA')
    expect(page).to have_text(I18n.l bill.due_date + 5.days)
    expect(page).to have_text('Pendente')
  end
end