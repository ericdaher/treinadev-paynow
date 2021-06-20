require 'rails_helper'

describe 'Supervisor regenerates token' do
  it 'sucessfully' do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    user = User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    old_token = company.id_token

    login_as user, scope: :user
    visit root_path
    click_on 'CodePlay'

    expect(page).to have_text(old_token)
    expect(page).to have_link('Gerar Novo Token')

    click_on 'Gerar Novo Token'

    company.reload
    new_token = company.id_token
    expect(page).to_not have_text(old_token)
    expect(page).to have_text(new_token)
    expect(page).to have_text('Novo Token gerado com sucesso')
  end

  it "can't regenerate when not supervisor" do
    company = Company.create!(name: 'CodePlay', cnpj: CNPJ.generate, email: 'faturamento@codeplay.com.br')
    User.create!(email: 'usuario@codeplay.com.br', password: '12345678', company: company)
    user = User.create!(email: 'usuario2@codeplay.com.br', password: '12345678', company: company)
    old_token = company.id_token

    login_as user, scope: :user
    visit root_path
    click_on 'CodePlay'

    expect(page).to have_text(old_token)
    expect(page).to_not have_link('Gerar Novo Token')
  end
end