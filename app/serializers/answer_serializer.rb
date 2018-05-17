class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :question_id, :created_at, :updated_at, :the_best

  has_many :comments
  has_many :attachments
end