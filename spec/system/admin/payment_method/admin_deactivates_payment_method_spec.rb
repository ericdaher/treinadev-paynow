require 'rails_helper'

describe 'Admin inactivates payment method' do
  it 'successfully' do
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    payment_method = PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                                           active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    
    login_as admin, scope: :admin
    visit admins_root_path

    expect(payment_method.active).to eq(true)

    login_as admin, scope: :admin
    visit admins_root_path
    click_on 'Meios de Pagamento'
    click_on 'VISA'
    click_on 'Inativar'

    payment_method.reload
    expect(payment_method.active).to eq(false)
    expect(page).to have_text 'Inativo'
  end

  it 'and activates' do
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    payment_method = PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                                           active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    
    payment_method.active = false
    payment_method.save!
    payment_method.reload

    expect(payment_method.active).to eq(false)

    login_as admin, scope: :admin
    visit admins_root_path
    click_on 'Meios de Pagamento'
    click_on 'VISA'
    click_on 'Ativar'

    payment_method.reload
    expect(payment_method.active).to eq(true)
    expect(page).to have_text 'Ativo'
  end
end