module Trestle
  module Auth
    module Backends
      class Warden < Base
        # Authenticates a user from a login form request.
        def authenticate!
          authenticate
        end

        # Authenticates the user using Warden.
        def authenticate
          warden.authenticate(scope: scope)
        end

        # Checks if there is a logged in user.
        def logged_in?
          warden.authenticated?(scope)
        end

        # Returns the current logged in user.
        def user
          warden.user(scope)
        end

        # Stores the given user as logged in.
        def login!(user)
          warden.set_user(user, scope: scope)
        end

        # Logs out the current user.
        def logout!
          if scope
            warden.logout(scope)
            warden.clear_strategies_cache!(scope: scope)
          else
            warden.logout
            warden.clear_strategies_cache!
          end
        end

        # Set the login params scope from configuration, which is also used as the Warden scope.
        def scope
          Trestle.config.auth.warden.scope
        end

      protected
        def warden
          request.env['warden']
        end
      end
    end
  end
end
