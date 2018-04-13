require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should have_many :attachments }
  it { should have_many :votes }


  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }


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
    let!(:answer) { question_with_answers.answers.first }

    context 'non-votes' do
      it 'creates the first vote' do
        expect { answer.to_vote(true, user) }.to change(answer.votes, :count).by(1)
      end

      it 'checks that given user_vote to method eq user vote in db' do
        answer.to_vote(true, user)
        expect(answer.votes.first.vote).to eq true
      end
    end

    context 'with votes' do
      it 'creates the first vote' do
        answer.votes.create(vote: true, user: user)
        vote = answer.votes.first
        answer.to_vote(false, user)
        expect(answer.votes.first).to_not eq vote
      end

      it 'checks that given user_vote to method is right' do
        answer.votes.create(vote: true, user: user)
        answer.to_vote(false, user)
        expect(answer.votes.first.vote).to eq false
      end
    end
  end


  describe '#voting_result' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user) }

    let!(:question_with_answers) { create(:question_answers) }

    it 'calculates voting result' do
      answer = question_with_answers.answers.first
      answer.to_vote(true, user1)
      answer.to_vote(true, user2)
      answer.to_vote(false, user3)

      hash = { :positive_count=>2, :negative_count=>1, :result=>"1", :positive_persent=>66.67, :negative_persent=>33.33 }

      expect(answer.voting_result).to eq hash
    end
  end
end