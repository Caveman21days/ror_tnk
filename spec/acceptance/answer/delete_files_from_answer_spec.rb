require_relative '../acceptance_helper'

feature 'Delete files from answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'user delete files than edits answer', js: true do
    within ".answer-#{answer.id}" do
      click_on 'Edit'
      click_on 'add file'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Save'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      click_on 'delete file'
      expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end