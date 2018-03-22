require 'rails_helper'

feature 'User sign in' do
  given(:user) { create(:user) }

  scenario 'registered user sign_in to system' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end

  scenario 'non-registered user sign_in to system' do
    visit new_user_session_path
    fill_in 'Email', with: 'caveman21days@y.ru'
    fill_in 'Password', with: '123qwerty12'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password'
    expect(current_path).to eq new_user_session_path
  end
end
