require_relative '../acceptance_helper'

feature 'User sign out' do
  given(:user) { create(:user) }

  scenario 'registered user sign_out from system' do
    sign_in(user)
    expect(page).to have_content 'Signed in successfully'
    click_on 'Logout'
    expect(page).to have_content 'Signed out successfully'
    expect(current_path).to eq root_path
  end
end
