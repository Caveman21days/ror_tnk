require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should have_many :attachments }
  it { should have_many :votes }


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

  describe '#to_vote' do
    let!(:user) { create(:user) }
    let!(:question_with_answers) { create(:question_answers) }

    it 'should create the first vote' do
      answer = question_with_answers.answers.first
      expect { answer.to_vote('true', user) }.to change(answer.votes, :count).by(1)
    end

    it 'should destroy user vote if type of vote eq existing vote' do
      current_user = user

      answer = question_with_answers.answers.first

      expect { answer.to_vote(true, current_user) }.to change(answer.votes, :count).by(1)
      expect(answer.to_vote(true, user)).to be_truthy
    end
  end

  describe '#voting_result' do
    let!(:user) { create(:user) }
    let!(:question_with_answers) { create(:question_answers) }

    it 'should create the first vote' do
      answer = question_with_answers.answers.first
      answer.to_vote('true', user)
      hash = { :positive_count=>1, :negative_count=>0, :positive_persent=>100.0, :negative_persent=>0.0, :result=>"+1" }

      expect(answer.voting_result).to eq hash
    end

    it 'should destroy user vote if type of vote eq existing vote' do
      current_user = user
      answer = question_with_answers.answers.first

      expect { answer.to_vote(true, current_user) }.to change(answer.votes, :count).by(1)
      expect(answer.to_vote(true, user)).to be_truthy
    end
  end
end