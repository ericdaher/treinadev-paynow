require 'rails_helper'

describe 'Visitor registers company' do
  it 'and attributes cannot be blank' do
    visit new_company_path

    fill_in 'Razão Social', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'Email para Faturamento', with: ''

    expect { click_on 'Criar Empresa' }.to_not change { Company.count }
    expect(page).to have_text('não pode ficar em branco', count: 3)
  end
end