require_relative '../acceptance_helper'

feature 'Delete question' do
  given(:user) { create(:user) }
  let(:user_with_question) { create(:user_with_question) }
  let(:question) { create(:question) }

  scenario 'authenticated user deleting question' do
    sign_in(user_with_question)
    question_title = user_with_question.questions.first.title
    visit questions_path

    click_on 'Delete'

    expect(page).to have_content 'Question was successfully destroyed.'
    expect(page).to_not have_content question_title
  end

  scenario 'authenticated user tries to delete their question' do
    sign_in(user)
    question

    visit questions_path

    expect(page).to have_content question.title
    expect(page).to_not have_content 'Delete'
  end

  scenario 'non-authenticated user deleting question' do
    visit questions_path
    expect(page).to_not have_content 'Delete'
  end
end