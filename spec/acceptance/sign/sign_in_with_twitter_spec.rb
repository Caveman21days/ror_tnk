require_relative '../acceptance_helper'

# В общем не работает current_email, нашел много issue, решений нет адекватных. в целом тест вроде верный
feature 'Sign in with twitter' do

  describe 'user sign_in' do

    background { visit new_user_session_path }

    scenario 'user sign_in successfully' do
      clear_emails
      mock_auth_hash
      email = 'user@example.com'

      click_on 'Sign in with Twitter'

      expect(page).to have_content('Please enter your email for confirmation')
      fill_in 'Email', with: email
      click_on 'Send'

      open_email(email)
      current_email.click_link 'CONFIRM ME'

      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Log out'
    end

    context 'with invalid credentials' do
      scenario 'user not sign_in' do
        mock_auth_invalid(:twitter)
        click_link 'Sign in with Twitter'
        expect(page).to have_content('Could not authenticate you from Twitter because "Credentials are invalid"')
      end
    end
  end
end