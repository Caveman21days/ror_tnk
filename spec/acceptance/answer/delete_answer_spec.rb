require 'rails_helper'


feature 'show question answers delete' do
  given(:user) { create(:user) }
  given!(:question_answers) { create(:question_answers) }
  let(:user_with_answer) { create(:user_with_answer) }

  scenario 'authenticated user can delete answer' do
    sign_in(user_with_answer)

    visit question_path(user_with_answer.answers.first.question)

    expect(page).to have_content user_with_answer.answers.first.question.title
    expect(page).to have_content user_with_answer.answers.first.body

    click_on 'Delete'

    expect(page).to have_content 'Your answer successfully deleted!'
    expect(page).to_not have_content 'MyAnswer_7'
  end

  scenario 'non-authenticated user can not delete answer' do
    visit question_path(question_answers)

    expect(page).to have_content question_answers.title
    expect(page).to have_content question_answers.answers[0].body
    expect(page).to have_content question_answers.answers[1].body
    expect(page).to have_content 'please sign in/sign up for answer'
    expect(page).to_not have_content 'Delete'
  end
end
