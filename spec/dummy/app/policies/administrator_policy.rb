class AdministratorPolicy
  def initialize(user, target)
    @user, @target = user, target
  end

  def show?
    @user == @target
  end
end
