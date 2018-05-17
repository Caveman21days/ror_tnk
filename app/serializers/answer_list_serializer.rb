class AnswerListSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :question_id, :created_at, :updated_at, :the_best
  # belongs_to :question, serializer: QuestionSerializer
end