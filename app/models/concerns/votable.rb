module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :delete_all
  end


  def to_vote(user_vote, current_user)
    v = self.votes.find_by(user: current_user)
    if !v.nil?
      v.destroy
      return true if v.vote == user_vote
    end

    self.votes.create(user: current_user, vote: user_vote)
  end



  def voting_result
    votes = self.votes

    result_of_voting = { positive_count: votes.where(vote: true).count,
                         negative_count: votes.where(vote: false).count,
                         result: (votes.where(vote: true).count - self.votes.where(vote: false).count).to_s,
                         positive_persent: 0,
                         negative_persent: 0 }

    if votes.count != 0
      result_of_voting[:positive_persent] = (result_of_voting[:positive_count].to_f/votes.count*100).round(2)
      result_of_voting[:negative_persent] = (result_of_voting[:negative_count].to_f/votes.count*100).round(2)
    end

    return result_of_voting
  end
end
