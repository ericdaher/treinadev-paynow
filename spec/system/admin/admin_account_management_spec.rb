require 'rails_helper'

describe 'Admin account management' do
  context 'admin creates new admin' do
    it 'successfully' do
      admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    
      login_as admin, scope: :admin
      visit admins_root_path
      click_on 'Criar Novo Usuário'

      fill_in 'Email', with: 'novo@paynow.com.br'
      fill_in 'Senha', with: '123456789'
      fill_in 'Confirmar Senha', with: '123456789'

      expect { click_on 'Criar Conta' }.to change { Admin.count }.by(1)
      expect(page).to have_text('Novo administrador criado com sucesso.')
    end

    it 'cannot create when not logged in' do
      visit new_admin_registration_path

      expect(current_path).to eq(new_admin_session_path)
      expect(page).to have_text('Para continuar, efetue login ou registre-se.')
    end

    it 'with invalid fields' do
      admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
      login_as admin, scope: :admin
      visit new_admin_registration_path

      expect { click_on 'Criar Conta' }.to_not change { Admin.count }
      expect(page).to have_text('não pode ficar em branco', count: 2)
    end

    it 'password not matching confirmation' do
      admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
      login_as admin, scope: :admin
      visit new_admin_registration_path

      fill_in 'Email', with: 'novo@paynow.com.br'
      fill_in 'Senha', with: '123456789'
      fill_in 'Confirmar Senha', with: '1234567'

      expect { click_on 'Criar Conta' }.to_not change { Admin.count }
      expect(page).to have_text('não é igual')
    end
  end

  context 'sign in' do
    it 'with email and password' do
      admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
      visit admins_root_path

      fill_in 'Email', with: 'admin@paynow.com.br'
      fill_in 'Senha', with: '12345678'
      click_on 'Fazer Login'

      expect(current_path).to eq(admins_root_path)
      expect(page).to have_text('Logado como admin@paynow.com.br')
    end
  end

  context 'log out' do
    it 'successfully' do
      admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
      login_as admin, scope: :admin
      visit admins_root_path

      expect(page).to have_text('Logado como admin@paynow.com.br')
      click_on 'Sair'
      
      expect(page).to have_text('Saiu com sucesso.')
    end
  end
end