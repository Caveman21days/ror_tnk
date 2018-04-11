class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  scope :sorted, -> { order(:the_best, created_at: :desc) }

  def set_the_best
    transaction do
      self.question.answers.update_all(the_best: nil)
      self.update!(the_best: true)
    end
  end
end
