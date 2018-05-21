require_relative '../acceptance_helper'

feature 'Add files to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'user adds any files than create object', js: true do
    within ".answer-#{answer.id}" do
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

  scenario 'user adds any files than create object', js: true do
    fill_in 'answer_body', with: 'test answer'
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

    within '.answers' do
      expect(page).to have_content'spec_helper.rb'
      expect(page).to have_content'rails_helper.rb'
    end
  end
end