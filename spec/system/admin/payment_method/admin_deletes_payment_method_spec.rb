require 'rails_helper'

describe 'Admin deletes payment method' do
  it 'successfully' do
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    payment_method = PaymentMethod.create!(name: 'VISA', method_type: "credit_card", payment_tax: 3.99, max_tax: 50, 
                                           active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    
    login_as admin, scope: :admin
    visit admins_root_path

    click_on 'Meios de Pagamento'
    click_on 'VISA'
    
    expect { click_on 'Excluir' }.to change { PaymentMethod.count }.by(-1)
    expect(current_path).to eq(admins_payment_methods_path)
    expect(page).to have_text('Meio de pagamento excluído com sucesso')
  end
end