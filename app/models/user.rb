class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :votes

  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def author_of?(obj)
    self.id == obj.user_id
  end
end
