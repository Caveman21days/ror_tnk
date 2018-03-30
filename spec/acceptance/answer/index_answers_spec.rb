require_relative '../acceptance_helper'

feature 'index answers' do
  given(:user) { create(:user) }
  given!(:question_answers) { create(:question_answers) }

  scenario 'authenticated user can see answers' do
    sign_in(user)

    visit question_path(question_answers)
    expect(page).to have_content question_answers.answers.first.body
    expect(page).to have_content question_answers.answers[1].body
  end

  scenario 'non-authenticated user can see answers' do
    visit question_path(question_answers)
    expect(page).to have_content question_answers.answers.first.body
    expect(page).to have_content question_answers.answers[1].body
    expect(page).to have_content 'please sign in/sign up for answer'
  end
end