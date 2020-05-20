class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, CancancanAdmin if user.super?
  end
end
