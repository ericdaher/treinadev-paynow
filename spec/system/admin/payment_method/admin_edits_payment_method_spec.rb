require 'rails_helper'

describe 'Admin edits payment method' do
  it 'successfully' do
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    payment_method = PaymentMethod.create!(name: 'VISA', method_type: "credit_card", payment_tax: 3.99, max_tax: 50, 
                                           active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    
    login_as admin, scope: :admin
    visit admins_root_path

    click_on 'Meios de Pagamento'
    click_on 'VISA'
    click_on 'Editar'

    fill_in 'Nome', with: 'MasterCard'
    click_on 'Finalizar Edição'

    expect(current_path).to eq(admins_payment_methods_path(payment_method))
    expect(page).to have_text('Meio de pagamento atualizado com sucesso')
  end
end