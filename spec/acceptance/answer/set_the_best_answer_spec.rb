require_relative '../acceptance_helper'

feature 'Answer set the best' do
  given(:user) { create(:user) }
  given(:question_with_answers) { create(:question_answers, user: user) }
  given(:question_with_answers2) { create(:question_answers) }

  scenario 'non-authenticated user try to set the best answer' do
    visit question_path(question_with_answers)

    expect(page).to_not have_link 'Best!'
  end

  describe 'Authenticated' do
    scenario 'author of question try to set the best answer', js: true do
      sign_in(user)
      visit question_path(question_with_answers)

      within ".answer-#{question_with_answers.answers.first.id}" do
        expect(page).to have_link 'Best!'

        click_on 'Best!'

        expect(page).to have_selector 'h4'
      end
    end

    scenario 'user try to set the best answer' do
      sign_in(user)
      visit question_path(question_with_answers2)

      within ".answer-#{question_with_answers2.answers.first.id}" do
        expect(page).to_not have_link 'Best!'
        expect(page).to_not have_selector 'h4'
      end
    end
  end
end