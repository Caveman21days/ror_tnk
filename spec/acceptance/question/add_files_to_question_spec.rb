require_relative '../acceptance_helper'

feature 'Add files to question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  before do
    sign_in(user)
  end

  scenario 'user adds files than asks question', js: true do
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'testtest'
    click_on 'add file'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Save'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'user adds files than edit question', js: true do
    visit question_path(question)

    within '.question' do
      click_on 'Edit'
      click_on 'add file'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Save'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end