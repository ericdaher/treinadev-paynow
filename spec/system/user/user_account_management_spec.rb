require 'rails_helper'

describe 'User account management' do
  context 'sign up' do
    it 'successfully' do
      company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      
      visit root_path
      click_on 'Fazer cadastro'

      fill_in 'Email', with: 'usuario@codeplay.com.br'
      fill_in 'Senha', with: '12345678'
      fill_in 'Confirmar Senha', with: '12345678'
      select 'CodePlay (@codeplay.com.br)', from: 'Empresa'
      click_on 'Criar Conta'

      expect(current_path).to eq(root_path)
      expect(page).to have_text('Logado como usuario@codeplay.com.br')
    end

    it "can't sign up without company" do
      visit root_path
      click_on 'Fazer cadastro'

      fill_in 'Email', with: 'usuario@codeplay.com.br'
      fill_in 'Senha', with: '12345678'
      fill_in 'Confirmar Senha', with: '12345678'

      expect { click_on 'Criar Conta' }.to_not change { User.count }
      expect(page).to have_text('é obrigatório(a)')
    end

    it 'can create company from sign up screen' do
      visit root_path
      click_on 'Fazer cadastro'

      click_on 'Adicionar Empresa'
      expect(current_path).to eq(new_company_path)

      fill_in 'Razão Social', with: 'CodePlay'
      fill_in 'CNPJ', with: CNPJ.generate
      fill_in 'Email para Faturamento', with: 'faturamento@codeplay.com.br'
      
      expect { click_on 'Criar Empresa' }.to change { Company.count }.by(1)
      expect(current_path).to eq(new_user_registration_path)
      expect(page).to have_text('Empresa criada com sucesso')     
    end

    it "email must be from the same domain as the company's email" do
      company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      
      visit root_path
      click_on 'Fazer cadastro'

      fill_in 'Email', with: 'usuario@exemplo.com.br'
      fill_in 'Senha', with: '12345678'
      fill_in 'Confirmar Senha', with: '12345678'
      select 'CodePlay (@codeplay.com.br)', from: 'Empresa'

      expect { click_on 'Criar Conta' }.to_not change { User.count }
      expect(page).to have_text('deve ter o mesmo domínio do email da empresa')
    end
  end

  context 'sign in' do
    it 'sucessfully' do
      company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
      
      visit root_path
      click_on 'Entrar'

      fill_in 'Email', with: 'usuario@codeplay.com.br'
      fill_in 'Senha', with: '12345678'
      click_on 'Fazer Login'

      expect(current_path).to eq(root_path)
      expect(page).to have_text('Logado como usuario@codeplay.com.br')
    end

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
    it 'successfully' do
      company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
      user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)

      login_as user, scope: :user
      visit root_path

      expect(page).to have_text('Logado como usuario@codeplay.com.br')
      click_on 'Sair'
      
      expect(page).to have_text('Saiu com sucesso.')
    end
  end
end