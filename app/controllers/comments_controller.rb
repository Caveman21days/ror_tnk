class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  after_action :publish_comment, only: [:create]


  def create
    @comment = @commentable.comments.build(comment_params.merge(user_id: current_user.id))

    if @comment.save
      render json: { message: "Your comment successfuly added!" }
    else
      message = "Your comment was not added =("
      render json: { errors: @comment.errors.full_messages, message: message }, status: :unprocessable_entity
    end
  end


  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    klass = [Question, Answer].find { |klass| params["#{klass.name.underscore}_id"] }
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def channel_id
    @commentable.class.name == "Question" ? @commentable.id : @commentable.question.id
  end

  def publish_comment
    ActionCable.server.broadcast(
      "comments_#{channel_id}",
      ApplicationController.render_with_signed_in_user(
        current_user,
        json: { comment: @comment,
                commentable_id: @commentable.id,
                commentable_type: @commentable.class.name.underscore
        }
      )
    )
  end
end
