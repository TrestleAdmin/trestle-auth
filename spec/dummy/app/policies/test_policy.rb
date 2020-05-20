class TestPolicy
  def initialize(user, target)
    @user, @target = user, target
  end

  def index?
    @user.super?
  end
end
