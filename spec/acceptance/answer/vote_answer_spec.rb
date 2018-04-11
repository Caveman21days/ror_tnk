require_relative '../acceptance_helper'

feature 'Vote for answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer1) { create(:answer, question: question) }
  given!(:user_answer) { create(:answer, question: question, user: user) }

  scenario 'Non-authenticated user try to vote for answer' do
    visit question_path(question)

    expect(page).to_not have_link 'vote up!'
    expect(page).to_not have_link 'vote for!'
  end

  describe 'Authenticated' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'user can vote for answer', js: true do
      within ".vote-links-#{answer1.id}" do
        expect(page).to have_link 'vote up!'
        expect(page).to have_link 'vote for!'

        click_on 'vote up!'
      end

      within ".vote-#{answer1.id}" do
        expect(page).to have_content '1 (100%) / 0 (0%) | +1'
      end
    end

    scenario 'user cant vote for his own answer', js: true do
      p user_answer.id
      within ".answer-#{user_answer.id}" do
        expect(page).to_not have_link 'vote up!'
        expect(page).to_not have_link 'vote for!'
      end
    end

    scenario 'user can revote', js: true do
      within ".answer-#{answer1.id}" do
        expect(page).to have_link 'vote up!'
        expect(page).to have_link 'vote for!'
        click_on 'vote up!'
        expect(page).to have_content '1 (100%) / 0 (0%) | +1'
        click_on 'vote for!'
        expect(page).to have_content '0 (0%) / 1 (100%) | -1'
      end
    end
  end
end