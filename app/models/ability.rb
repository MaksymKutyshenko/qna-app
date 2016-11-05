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
    can :create, [Question, Answer, Comment, Vote]
    can :update, [Question, Answer, Vote], user: user
    can :destroy, [Question, Answer, Vote], user: user
    
    can :destroy, Attachment do |attachment|
      user.author_of?(attachment.attachable)
    end 
    can :best, Answer do |answer|
      user.author_of?(answer.question)
    end 
    can :rate, [Question, Answer] do |votable|
      !user.author_of?(votable)
    end 
    can :unrate, [Question, Answer] do |votable|
      user.voted_for?(votable)
    end    
  end
end
