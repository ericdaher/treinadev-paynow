require 'rails_helper'

describe 'Admin visits homepage' do
  it 'successfully' do
    admin = Admin.create!(email: 'admin@paynow.com.br', password: '12345678')
    
    login_as admin, scope: :admin
    visit admins_root_path

    expect(page).to have_text('Bem vindo à area administrativa da PayNow.')
  end

  it 'redirects to login when not logged in' do
    visit admins_root_path

    expect(current_path).to eq(new_admin_session_path)
    expect(page).to have_text('Para continuar, efetue login ou registre-se.')
  end
end