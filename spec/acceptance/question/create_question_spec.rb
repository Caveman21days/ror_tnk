require_relative '../acceptance_helper'

feature 'Create question' do
  given(:user) { create(:user) }

  scenario 'authenticated user creating question' do
    sign_in(user)

    visit questions_path

    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'testtest'
    click_on 'Save'

    expect(page).to have_content 'Question was successfully created.'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'testtest'
  end

  scenario 'non-authenticated user creating question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'authenticated user create invalid-question' do
    sign_in(user)

    visit questions_path

    click_on 'Ask question'
    fill_in 'Body', with: 'testtest'
    click_on 'Save'

    expect(page).to have_content "Title can't be blank"
  end
end

feature 'multiple sessions', :js do
  given(:user) { create(:user) }

  scenario "question appears on another user's page" do
    Capybara.using_session('user') do
      sign_in(user)
      visit questions_path
    end

    Capybara.using_session('guest') do
      visit questions_path
    end

    Capybara.using_session('user') do
      click_on 'Ask question'
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'testtest'
      click_on 'Save'

      expect(page).to have_content 'Question was successfully created.'

      expect(page).to have_content 'Test question'
      expect(page).to have_content 'testtest'
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'Test question'
    end
  end
end
