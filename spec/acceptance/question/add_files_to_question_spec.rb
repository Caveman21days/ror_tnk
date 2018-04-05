require_relative '../acceptance_helper'

feature 'Add files to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  before do
    sign_in(user)
  end

  scenario 'user adds any files than edit question', js: true do
    visit question_path(question)

    within '.question' do
      click_on 'Edit'
      click_on 'add file'
      click_on 'add file'

      fields = page.all('.nested-fields')

      within fields[0] do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      end

      within fields[1] do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      end

      click_on 'Save'

      expect(page).to have_content'spec_helper.rb'
      expect(page).to have_content'rails_helper.rb'
    end
  end

  scenario 'user adds any files than asks question', js: true do
    visit new_question_path

    save_and_open_page
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'testtest'

    click_on 'add file'
    click_on 'add file'

    fields = page.all('.nested-fields')

    within fields[0] do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    within fields[1] do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Save'

    expect(page).to have_content'spec_helper.rb'
    expect(page).to have_content'rails_helper.rb'

  end
end
