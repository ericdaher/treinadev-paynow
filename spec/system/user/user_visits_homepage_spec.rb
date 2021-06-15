require 'rails_helper'

describe 'User visits homepage' do
  it 'successfully' do
    visit root_path
    expect(page).to have_text('Bem vindo à PayNow.')
  end
end