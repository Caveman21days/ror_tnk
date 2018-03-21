require 'rails_helper'

feature 'Create question page' do
  given(:user) { create(:user) }

  scenario 'authenticated user creating question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'testtest'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created'

    visit questions_path
    click_on 'Delete question'

    expect(page).to have_content 'Question successfully deleted!'
  end

  scenario 'non-authenticated user creating question' do
    visit questions_path

    expect(page).to_not have_content 'Delete question'
  end
end