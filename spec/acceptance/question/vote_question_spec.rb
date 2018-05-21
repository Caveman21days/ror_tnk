require_relative '../acceptance_helper'

feature 'Vote for question' do
  given(:user) { create(:user) }
  given!(:object) { create(:question) }
  given!(:user_object) { create(:question, user: user) }
  given(:path) { questions_path }
  given(:obj_name) { 'question' }

  it_behaves_like "Voting"
end