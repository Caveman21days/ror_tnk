require_relative '../acceptance_helper'

feature 'show question' do
  given(:user) { create(:user) }
  given!(:question_answers) { create(:question_answers) }
  let(:user_with_answer) { create(:user_with_answer) }

  scenario 'authenticated user can see question' do
    sign_in(user)

    visit question_path(question_answers)
    expect(page).to have_content question_answers.title
  end

  scenario 'non-authenticated user can see question' do

    visit question_path(question_answers)
    expect(page).to have_content question_answers.title
    expect(page).to have_content question_answers.answers[0].body, question_answers.answers[1].body
    expect(page).to have_content 'please sign in/sign up for answer'

    expect(page).to_not have_content 'answer_body'
    expect(page).to_not have_content 'Delete'
  end
end
