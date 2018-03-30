require_relative '../acceptance_helper'

feature 'registration in system' do
  given(:user) { build(:user) }

  scenario 'registration with valid values' do
    visit new_user_registration_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(current_path).to eq root_path
  end
end