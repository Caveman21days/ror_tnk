require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many :attachments }
  it { should have_many :votes }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }



  describe '#to_vote' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }

    context 'non-votes' do
      it 'creates the first vote' do
        expect { question.to_vote(true, user) }.to change(question.votes, :count).by(1)
      end

      it 'destroys user vote if type of vote eq existing vote' do
        question.to_vote(true, user)
        expect(question.votes.first.vote).to eq true
      end
    end

    context 'with votes' do
      it 'creates the first vote' do
        question.votes.create(vote: true, user: user)
        vote = question.votes.first
        question.to_vote(false, user)
        expect(question.votes.first).to_not eq vote
      end

      it 'destroys user vote if type of vote eq existing vote' do
        question.votes.create(vote: true, user: user)
        question.to_vote(false, user)
        expect(question.votes.first.vote).to eq false
      end
    end
  end


  describe '#voting_result' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user) }

    let!(:question) { create(:question) }

    it 'calculates voting result' do
      question.to_vote(true, user1)
      question.to_vote(true, user2)
      question.to_vote(false, user3)

      hash = {:positive_count=>2, :negative_count=>1, :result=>"1", :positive_persent=>66, :negative_persent=>33}

      expect(question.voting_result).to eq hash
    end
  end
end
