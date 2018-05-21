require_relative '../acceptance_helper'

feature 'Add comments for question' do
  given(:user) { create(:user) }
  given!(:object) { create(:question) }
  given!(:question) { object }
  given!(:obj_name) { "question" }
  given!(:obj_names) { "question" }


  it_behaves_like "Commenting"
end