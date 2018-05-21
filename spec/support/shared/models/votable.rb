shared_examples_for "Votable" do
  describe '#to_vote' do
    let!(:user) { create(:user) }

    context 'non-votes' do
      it 'creates the first vote' do
        expect { votable_object.to_vote(true, user) }.to change(votable_object.votes, :count).by(1)
      end

      it 'checks that given user_vote to method eq user vote in db' do
        votable_object.to_vote(true, user)
        expect(votable_object.votes.first.vote).to eq true
      end
    end

    context 'with votes' do
      it 'creates the first vote' do
        votable_object.votes.create(vote: true, user: user)
        vote = votable_object.votes.first
        votable_object.to_vote(false, user)
        expect(votable_object.votes.first).to_not eq vote
      end

      it 'checks that given user_vote to method is right' do
        votable_object.votes.create(vote: true, user: user)
        votable_object.to_vote(false, user)
        expect(votable_object.votes.first.vote).to eq false
      end
    end
  end


  describe '#voting_result' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user) }


    it 'calculates voting result' do
      votable_object.to_vote(true,  user1)
      votable_object.to_vote(true,  user2)
      votable_object.to_vote(false, user3)

      hash = { :positive_count=>2, :negative_count=>1, :result=>"1", :positive_persent=>66.67, :negative_persent=>33.33 }

      expect(votable_object.voting_result).to eq hash
    end
  end
end