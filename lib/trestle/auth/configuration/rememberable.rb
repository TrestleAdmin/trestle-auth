module Trestle
  module Auth
    class Configuration
      class Rememberable
        include Configurable

        option :enabled, true

        option :for, 2.weeks

        option :authenticate, ->(token) {
          scope = Trestle.config.auth.user_scope
          scope.authenticate_with_remember_token(token)
        }

        option :remember_me, ->(user) {
          user.remember_me!
        }

        option :forget_me, ->(user) {
          user.forget_me!
        }

        option :cookie, ->(user) {
          { value: user.remember_token, expires: user.remember_token_expires_at }
        }
      end
    end
  end
end
