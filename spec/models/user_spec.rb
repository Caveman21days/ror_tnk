require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  describe '#author_of?' do
    let(:user_with_answer) { create(:user_with_answer) }
    let(:user_with_question) { create(:user_with_question) }
    let(:user) { create(:user) }
    let(:question_with_answers) { create(:question_answers) }
    let(:answer) { question_with_answers.answers.first }

    it 'When user is not owner of answer its falsey' do
      expect(user.author_of?(answer)).to be_falsey
    end

    it 'When user is owner of answer its truthy' do
      expect(user_with_answer.author_of?(user_with_answer.answers.first)).to be_truthy
    end

    it 'When user is not owner of question its falsey' do
      expect(user.author_of?(question_with_answers)).to be_falsey
    end

    it 'When user is owner of question its truthy' do
      expect(user_with_question.author_of?(user_with_question.questions.first)).to be_truthy
    end
  end
end