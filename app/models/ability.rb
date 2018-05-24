class Ability
  include CanCan::Ability

  attr_reader :user


  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end


  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create,  [Question, Answer, Comment, Subscribe]
    can :update,  [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer, Subscribe], user_id: user.id
    can :destroy, Attachment, attachable: { user_id: user.id }

    can :set_the_best, Answer, question: { user_id: user.id }

    can :vote, [Question, Answer] do |obj|
      !user.author_of?(obj)
    end

    can [:me, :index], User
  end
end
