require 'rails_helper'

describe 'Admin visits homepage' do
  it 'successfully' do
    admin = Admin.create!(email: 'admin@paynow.com', password: '12345678')
    
    login_as admin, scope: :admin
    visit admin_root_path

    expect(page).to have_text('Bem vindo à area administrativa da PayNow.')
  end

  it 'redirects to login when not logged in' do
    visit admin_root_path

    expect(page).to have_text('Para continuar, efetue login ou registre-se.')
    expect(current_path).to eq(new_admin_session_path)
  end
end