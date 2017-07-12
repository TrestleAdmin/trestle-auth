module Trestle::Auth::UserHelper
  def format_user_name(user)
    if user.respond_to?(:first_name) && user.respond_to?(:last_name)
      safe_join([user.first_name, content_tag(:strong, user.last_name)], " ")
    else
      display(user)
    end
  end

  def avatar_for(user)
    avatar { instance_exec(user, &Trestle.config.auth.avatar) } if Trestle.config.auth.avatar
  end
end
