require_relative '../acceptance_helper'

feature 'Add comments for answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:object) { create(:answer, question: question) }
  given!(:obj_name) { "answer" }
  given!(:obj_names) { "answers" }


  it_behaves_like "Commenting"
end

