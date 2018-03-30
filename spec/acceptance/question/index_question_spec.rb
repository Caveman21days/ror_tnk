require_relative '../acceptance_helper'

feature 'index question page' do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2) }

  scenario 'authenticated user can see questions' do
    sign_in(user)
    visit questions_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
  end

  scenario 'non-authenticated user can see questions' do
    visit questions_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
  end
end
