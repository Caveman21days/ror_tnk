require_relative '../acceptance_helper'


feature 'delete answer' do
  given(:user) { create(:user) }
  given(:question_answers) { create(:question_answers) }
  let(:user_with_answer) { create(:user_with_answer) }

  scenario 'authenticated user can delete answer', js: true do
    sign_in(user_with_answer)
    answer_body = user_with_answer.answers.first.body

    visit question_path(user_with_answer.answers.first.question)

    expect(page).to have_content answer_body

    within '.answers' do
      click_on 'Delete'
    end

    expect(page).to have_content 'Answer was successfully destroyed.'
    expect(page).to_not have_content answer_body
  end

  scenario 'non-authenticated user can not delete answer', js: true do
    visit question_path(question_answers)

    expect(page).to have_content question_answers.title
    expect(page).to have_content 'please sign in/sign up for answer'

    within '.answers' do
      expect(page).to have_content question_answers.answers[0].body
      expect(page).to have_content question_answers.answers[1].body
      expect(page).to_not have_content 'Delete'
    end
  end
end
