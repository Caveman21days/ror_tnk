class Question < ApplicationRecord
  include Votable
  include Commentable


  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :subscribes, dependent: :destroy

  validates :title, :body, presence: true

  scope :sorted, -> { order(created_at: :desc) }
  scope :last_day, -> { where('created_at >= ?', (Date.today - 1.day).to_datetime) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  after_create :subscribe_me


  private

  def subscribe_me
    self.subscribes.create(user_id: self.user_id)
  end
end
