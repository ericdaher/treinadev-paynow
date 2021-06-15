require 'rails_helper'

describe 'Admin account management' do
  context 'admin creates new admin' do
    it 'successfully' do
      admin = Admin.create!(email: 'admin@paynow.com', password: '12345678')
    
      login_as admin, scope: :admin
      visit admin_root_path
      click_on 'Criar Novo Usuário'

      fill_in 'Email', with: 'novo@paynow.com'
      fill_in 'Senha', with: '123456789'
      fill_in 'Confirmar Senha', with: '123456789'

      expect { click_on 'Criar Conta' }.to change { Admin.count }.by(1)
      expect(page).to have_text('Novo administrador criado com sucesso.')
    end

    it 'cannot create when not logged in' do
      visit new_admin_registration_path

      expect(page).to have_text('Para continuar, efetue login ou registre-se.')
    end
  end

  context 'sign in' do
    
  end

  context 'log out' do
    
  end
end