require 'rails_helper'

feature 'show question answers create' do
  given(:user) { create(:user) }
  given!(:question_answers) { create(:question_answers) }
  let(:user_with_answer) { create(:user_with_answer) }

  scenario 'authenticated user can create answer' do
    sign_in(user)

    visit question_path(question_answers)

    expect(page).to have_content question_answers.answers[0].body
    expect(page).to have_content question_answers.answers[1].body

    fill_in 'answer_body', with: 'test_answer_for_auth_user'
    click_on 'Submit'

    expect(page).to have_content 'test_answer_for_auth_user'
  end

  scenario 'non-authenticated user can not create' do
    visit question_path(question_answers)

    expect(page).to have_content question_answers.title
    expect(page).to have_content question_answers.answers[0].body
    expect(page).to have_content question_answers.answers[1].body
    expect(page).to have_content 'please sign in/sign up for answer'

    expect(page).to_not have_content 'answer_body'
  end
end
