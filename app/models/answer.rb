class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :sorted, -> { order(the_best: :desc, created_at: :desc) }


  def set_the_best
    transaction do
      self.question.answers.each do |answer|
        answer.update!(the_best: nil)
      end
      self.update!(the_best: true)
    end
  end
end
