require 'rails_helper'

describe 'Supervisor blocks user' do
  it 'successfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    supervisor = User.create!(email: 'supervisor@codeplay.com.br', password: '12345678', company: company)
    common = User.create!(email: 'comum@codeplay.com.br', password: '12345678', company: company)

    expect(common.active).to eq(true)

    login_as supervisor, scope: :user
    visit root_path
    click_on 'CodePlay'

    expect(page).to have_text('supervisor@codeplay.com.br')
    expect(page).to have_text('comum@codeplay.com.br')

    click_on 'Desativar usuário'

    common.reload
    expect(common.active).to eq(false)
  end

  it 'and unblocks' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    supervisor = User.create!(email: 'supervisor@codeplay.com.br', password: '12345678', company: company)
    common = User.create!(email: 'comum@codeplay.com.br', password: '12345678', company: company)
    
    common.active = false
    common.save!
    common.reload

    expect(common.active).to eq(false)

    login_as supervisor, scope: :user
    visit root_path
    click_on 'CodePlay'

    expect(page).to have_text('supervisor@codeplay.com.br')
    expect(page).to have_text('comum@codeplay.com.br')

    click_on 'Ativar usuário'

    common.reload
    expect(common.active).to eq(true)
  end

  it "and blocked user can't access system" do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    supervisor = User.create!(email: 'supervisor@codeplay.com.br', password: '12345678', company: company)
    common = User.create!(email: 'comum@codeplay.com.br', password: '12345678', company: company)
    
    common.active = false
    common.save!
    common.reload

    expect(common.active).to eq(false)

    visit root_path
    click_on 'Entrar'

    fill_in 'Email', with: 'comum@codeplay.com.br'
    fill_in 'Senha', with: '12345678'
    click_on 'Fazer Login'

    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_text('Sua conta foi desativada.')
  end
end