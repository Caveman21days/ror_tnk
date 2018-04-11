module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :delete_all
  end


  def to_vote(user_vote, current_user)
    if current_user.votes.any? { |vote| vote.votable_id == self.id }
      v = current_user.votes.find_by(votable_id: self.id)
      v.destroy
      return true if v.vote.to_s == user_vote
    end

    self.votes.create(user_id: current_user.id, vote: user_vote)
  end



  def voting_result
    votes = self.votes.count
    if votes != 0
      positive_votes = self.votes.where(vote: true).count
      negative_votes = self.votes.where(vote: false).count

      positive_persent = (positive_votes.to_f/votes)*100
      negative_persent = (negative_votes.to_f/votes)*100

      r = positive_votes - negative_votes

      if r > 0
        result = "+#{r}"
      elsif r < 0
        result = "#{r}"
      else
        result = 0.0
      end

      result_of_voting = { positive_count: positive_votes,
                       negative_count: negative_votes,
                       positive_persent: positive_persent,
                       negative_persent: negative_persent,
                       result: result }
    else
      result_of_voting = { positive_count: 0,
                           negative_count: 0,
                           positive_persent: 0,
                           negative_persent: 0,
                           result: 0 }
    end
    return result_of_voting
  end
end
