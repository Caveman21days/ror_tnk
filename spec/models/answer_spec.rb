require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should have_many :attachments }

  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :attachments}

  describe '#set_the_best' do
    let!(:user) { create(:user) }
    let!(:question_with_answers) { create(:question_answers, user: user) }

    it 'Then author set_the_best answer' do
      answer = question_with_answers.answers.first
      answer.set_the_best
      expect(answer.the_best).to be_truthy
    end

    it 'Then author set_the_best another answer' do
      answer1 = question_with_answers.answers[0]
      answer2 = question_with_answers.answers[1]

      answer1.update(the_best: true)
      expect(answer1).to be_the_best

      answer2.set_the_best
      expect(answer2).to be_the_best
    end
  end
end