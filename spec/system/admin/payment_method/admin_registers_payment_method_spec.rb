require 'rails_helper'

describe 'Admin registers payment method' do
  it 'successfully' do
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    
    login_as admin, scope: :admin
    visit admins_root_path

    click_on 'Meios de Pagamento'
    click_on 'Adicionar Novo'

    fill_in 'Nome', with: 'VISA'
    select 'Cartão de Crédito', from: 'Tipo'
    fill_in 'Taxa (%)', with: 3.99
    fill_in 'Taxa máxima', with: 50.00
    attach_file 'Ícone', Rails.root.join('spec/fixtures/visa_logo.gif')
    click_on 'Criar Meio de Pagamento'

    expect(current_path).to eq(admins_payment_methods_path)
    expect(page).to have_text('Meio de pagamento criado com sucesso')
    expect(page).to have_text('VISA')
    expect(page).to have_text('Cartão de Crédito')
  end

  it 'and attributes cannot be blank' do
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    
    login_as admin, scope: :admin
    visit new_admins_payment_method_path

    expect { click_on 'Criar Meio de Pagamento' }.to_not change { Company.count }
    expect(page).to have_text('não pode ficar em branco', count: 4)
  end

  it 'and cannot create when not logged in as admin' do
    visit new_admins_payment_method_path

    expect(current_path).to eq(new_admin_session_path)
    expect(page).to have_text('Para continuar, efetue login ou registre-se.')
  end
end