module Trestle
  module Auth
    class Constraint
      def matches?(request)
        Trestle.config.auth.find_user(request.session[:trestle_user]) if request.session[:trestle_user]
      end
    end
  end
end
