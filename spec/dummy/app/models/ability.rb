class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, CancancanAdmin if user.super?
    can :manage, user
  end
end
