require 'rails_helper'

describe 'Admin views payment method' do
  it 'successfully' do
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    PaymentMethod.create!(name: 'Boleto', method_type: "ticket", payment_tax: 2.99, max_tax: 40, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    PaymentMethod.create!(name: 'PIX', method_type: "pix", payment_tax: 0.99, max_tax: 30, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    
    login_as admin, scope: :admin
    visit admins_root_path

    click_on 'Meios de Pagamento'

    expect(page).to have_text('VISA')
    expect(page).to have_text('Cartão de Crédito')
    expect(page).to have_text('Boleto')
    expect(page).to have_text('Boleto Bancário')
    expect(page).to have_text('PIX')
    expect(page).to have_text('PIX')
  end

  it 'and view details' do
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    
    login_as admin, scope: :admin
    visit admins_root_path

    click_on 'Meios de Pagamento'
    click_on 'VISA'

    expect(page).to have_text('VISA')
    expect(page).to have_css('img[src*="visa_logo.gif"]')
    expect(page).to have_text('Cartão de Crédito')
    expect(page).to have_text('3,99')
    expect(page).to have_text('R$ 50,00')
    expect(page).to have_text('Ativo')
  end

  it "and can't view when not logged in" do
    PaymentMethod.create!(name: 'VISA', method_type: "credit", payment_tax: 3.99, max_tax: 50, 
                          active: true, icon: fixture_file_upload(Rails.root.join('spec/fixtures/visa_logo.gif'), 'visa_logo.gif'))
    
    visit admins_payment_methods_path

    expect(page).to_not have_text('VISA')
    expect(page).to_not have_text('Cartão de Crédito')
    expect(current_path).to eq(new_admin_session_path)
    expect(page).to have_text('Para continuar, efetue login ou registre-se.')
  end
end