require_relative '../acceptance_helper'

feature 'Add comments for answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Unauthorized user can not add comment' do
    visit question_path(question)

    within ".answers .answer-#{answer.id} .comments" do
      expect(page).to_not have_link("add comment")
    end
  end

  describe 'Authorized user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can add comment', :js do
      within ".answer-#{answer.id} .comments" do
        click_on 'add comment'

        expect(page).to_not have_link 'add comment'

        fill_in 'Comment', with: 'test comment'
        click_on 'Save'

        expect(page).to have_link 'add comment'
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content 'test comment'
      end
      expect(page).to have_content "Your comment successfuly added!"
    end

    scenario 'can not add empty comment', :js do
      within ".answer-#{answer.id} .comments" do
        click_on 'add comment'
        expect(page).to_not have_link 'add comment'
        fill_in 'Comment', with: ''
        click_on 'Save'

        expect(page).to have_content "Your comment was not added =("
      end
      expect(page).to have_content "Body can't be blank"
    end
  end


  feature 'multiple session' do
    scenario "comment appears on another user's page", :js do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within ".answer-#{answer.id} .comments" do
          click_on 'add comment'

          expect(page).to_not have_link 'add comment'

          fill_in 'Comment', with: 'test comment'
          click_on 'Save'

          expect(page).to have_link 'add comment'
          expect(page).to_not have_selector 'textarea'
          expect(page).to have_content 'test comment'
        end
        expect(page).to have_content "Your comment successfuly added!"
      end

      Capybara.using_session('guest') do
        within ".answer-#{answer.id} .comments" do
          expect(page).to have_content 'test comment'
        end
      end
    end
  end
end

