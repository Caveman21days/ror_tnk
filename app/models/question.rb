class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :title, :body, presence: true

  scope :sorted, -> { order(created_at: :desc) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank
end
