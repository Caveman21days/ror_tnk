class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def set_the_best
    self.question.answers.update_all(the_best: nil)
    self.the_best = true
    save
  end
end
