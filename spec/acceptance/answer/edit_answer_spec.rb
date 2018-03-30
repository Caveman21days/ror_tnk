require_relative '../acceptance_helper'

feature 'Answer editing' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:question_answers) { create(:question_answers) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'non-authenticated user try to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated' do
    scenario 'author try to edit answer', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_link 'Edit'

        click_on 'Edit'
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'user try to edit answer' do
      sign_in(user)
      visit question_path(question_answers)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end
end