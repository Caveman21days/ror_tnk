shared_examples_for "Voting" do
  scenario "Non-authenticated user try to vote for object" do
    visit path

    expect(page).to_not have_link 'vote up!'
    expect(page).to_not have_link 'vote for!'
  end

  describe 'Authenticated' do
    before do
      sign_in(user)
      visit path
    end

    scenario "user can vote for object", js: true do
      within ".vote-links-#{object.id}" do
        expect(page).to have_link 'vote up!'
        expect(page).to have_link 'vote for!'

        click_on 'vote up!'
      end

      within ".vote-#{object.id}" do
        expect(page).to have_content '1 (100%) / 0 (0%) | 1'
      end
    end

    scenario "user cant vote for his own object", js: true do
      within ".#{obj_name}-#{user_object.id}" do
        expect(page).to_not have_link 'vote up!'
        expect(page).to_not have_link 'vote for!'
      end
    end

    scenario 'user can revote', js: true do
      within ".#{obj_name}-#{object.id}" do
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
