shared_examples_for "Add attachments" do
  # В общем, у меня ни в какую не получается сделать тест универсальным в силу концепции вьюх
  #
  scenario "user adds any files than edit object", js: true do
    within "#{block_name_1}-1" do
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

    within "#{block_name_2}" do
      expect(page).to have_content'spec_helper.rb'
      expect(page).to have_content'rails_helper.rb'
    end
  end
end