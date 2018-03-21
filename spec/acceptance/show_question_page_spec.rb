require 'rails_helper'

feature 'show question page' do
  given(:user) { create(:user) }
  given(:question_answers) { create(:question_answers) }

  scenario 'authenticated user can see, create and delete(his own answers) answers of question' do
    sign_in(user)
    question_answers

    visit question_path(question_answers)
    expect(page).to have_content question_answers.title
    expect(page).to have_content question_answers.answers[0].body, question_answers.answers[1].body
    fill_in 'answer_body', with: 'test_answer_for_auth_user'
    click_on 'Submit'

    expect(page).to have_content 'test_answer_for_auth_user'

    click_on 'Delete'

    expect(page).to have_content 'Answer successfully deleted!'
    expect(question_answers.answers.size).to eq 2
  end

  scenario 'non-authenticated user can see but cant create answers answer for the question' do
    question_answers

    visit question_path(question_answers)
    expect(page).to have_content question_answers.title
    expect(page).to have_content question_answers.answers[0].body, question_answers.answers[1].body
    expect(page).to have_content 'please sign in/sign up for answer'

    expect(page).to_not have_content 'answer_body'
    expect(page).to_not have_content 'Delete'
  end
end
