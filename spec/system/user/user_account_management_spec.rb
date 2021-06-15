require 'rails_helper'

describe 'User account management' do
  context 'sign up' do
    xit 'successfully' do
    end
  end

  context 'sign in' do
    it 'redirects to admin area when email is @paynow.com.br' do
      admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
      
      visit root_path
      click_on 'Entrar'

      fill_in 'Email', with: 'admin@paynow.com.br'
      fill_in 'Senha', with: '12345678'
      click_on 'Fazer Login'

      expect(current_path).to eq(new_admin_session_path)
      expect(page).to have_text('E-mails da PayNow são usados por administradores. Se você for um administrador, por favor faça login.')
    end
  end

  context 'log out' do
    xit 'successfully' do
    end
  end
end