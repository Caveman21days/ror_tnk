require_relative '../acceptance_helper'

feature 'Add files to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'user adds files than asks question', js: true do
    fill_in 'answer_body', with: 'test answer'
    click_on 'add file'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on 'Save'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'user adds files than edit answer', js: true do
    within ".answer-#{answer.id}" do
      click_on 'Edit'
      click_on 'add file'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Save'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  # Проверять что не автор не может добавить файл не вижу смысла,
  # поскольку это можно сделать только в рамках редактирования,
  # которое уже проверялось
end