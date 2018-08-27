module Trestle::Auth::UserHelper
  def format_user_name(user)
    instance_exec(user, &Trestle.config.auth.format_user_name)
  end

  def avatar_for(user)
    instance_exec(user, &Trestle.config.auth.avatar) if Trestle.config.auth.avatar
  end
end
