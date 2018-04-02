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
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'author can sees edit link' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'author try to edit his answer', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'user try to edit answer' do
      visit question_path(question_answers)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end
end