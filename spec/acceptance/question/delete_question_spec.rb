require 'rails_helper'

feature 'Delete question' do
  given(:user) { create(:user) }
  let(:user_with_question) { create(:user_with_question) }
  let(:question) { create(:question) }

  scenario 'authenticated user deleting question' do
    sign_in(user_with_question)
    visit questions_path
    click_on 'Delete'
    expect(page).to have_content 'Question successfully deleted!'
    expect(page).to_not have_content 'title_10'
  end

  scenario 'authenticated user tries to delete their question' do
    sign_in(user)
    question

    visit questions_path
    expect(page).to_not have_content 'title_10'
    expect(page).to_not have_content 'Delete'
  end

  scenario 'non-authenticated user deleting question' do
    visit questions_path
    expect(page).to_not have_content 'Delete'
  end
end