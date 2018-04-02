require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should validate_presence_of :body }

  describe '#set_the_best' do
    let!(:user) { create(:user) }
    let!(:question_with_answers) { create(:question_answers, user: user) }

    it 'Then author set_the_best answer' do
      answer = question_with_answers.answers.first
      answer.set_the_best
      expect(answer.the_best).to be_truthy
    end

    it 'Then author set_the_best another answer' do
      answer = question_with_answers.answers[1]
      answer.set_the_best
      expect(answer.the_best).to be_truthy
      expect(question_with_answers.answers.first.the_best).to eq nil
    end
  end
end