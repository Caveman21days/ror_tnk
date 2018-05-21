require_relative '../acceptance_helper'

feature 'Vote for answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:object) { create(:answer, question: question) }
  given!(:user_object) { create(:answer, question: question, user: user) }
  given(:path) { question_path(question) }
  given(:obj_name) { 'answer' }

  it_behaves_like "Voting"
end