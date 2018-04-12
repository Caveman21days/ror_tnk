require_relative '../acceptance_helper'

feature 'Vote for question' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:user_question) { create(:question, user: user) }

  scenario 'Non-authenticated user try to vote for question' do
    visit questions_path

    expect(page).to_not have_link 'vote up!'
    expect(page).to_not have_link 'vote for!'
  end

  describe 'Authenticated' do
    before do
      sign_in(user)
      visit questions_path
    end

    scenario 'user can vote for question', js: true do
      within ".vote-links-#{question.id}" do
        expect(page).to have_link 'vote up!'
        expect(page).to have_link 'vote for!'

        click_on 'vote up!'
      end

      within ".vote-#{question.id}" do
        expect(page).to have_content '1 (100%) / 0 (0%) | 1'
      end
    end

    scenario 'user cant vote for his own question', js: true do
      within ".question-#{user_question.id}" do
        expect(page).to_not have_link 'vote up!'
        expect(page).to_not have_link 'vote for!'
      end
    end

    scenario 'user can revote', js: true do
      within ".question-#{question.id}" do
        expect(page).to have_link 'vote up!'
        expect(page).to have_link 'vote for!'
        click_on 'vote up!'
        expect(page).to have_content '1 (100%) / 0 (0%) | 1'
        click_on 'vote for!'
        expect(page).to have_content '0 (0%) / 1 (100%) | -1'
      end
    end
  end
end