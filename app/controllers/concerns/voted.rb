module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote]
  end


  def vote
    if current_user && !current_user.author_of?(@votable)
      @votable.to_vote(params[:user_vote], current_user)

      respond_to do |format|
        if @votable.errors.any?
          format.json { render json: @votable.errors.full_messages, status: :unprocessible_entity }
        else
          format.json { render json: @votable.voting_result, notice: 'Your vote was saved!' }
        end
      end
    end
  end



  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end