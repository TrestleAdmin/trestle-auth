module Trestle
  module Auth
    module Backends
      class Basic < Base
        # Returns the current logged in user (after #authentication).
        attr_reader :user

        # Authenticates a user from a login form request.
        def authenticate!
          params = login_params

          if user = Trestle.config.auth.authenticate(params)
            login!(user)
            remember_me! if Trestle.config.auth.remember.enabled && params[:remember_me]
            user
          end
        end

        # Authenticates a user from the session or cookie. Called on each request via a before_action.
        def authenticate
          @user = find_authenticated_user || find_remembered_user
        end

        # Checks if there is a logged in user.
        def logged_in?
          !!user
        end

        # Stores the given user in the session as logged in.
        def login!(user)
          session[:trestle_user] = user.id
          @user = user
        end

        # Logs out the current user.
        def logout!
          if logged_in? && Trestle.config.auth.remember.enabled
            Trestle.config.auth.remember.forget_me(user)
            cookies.delete(:trestle_remember_token)
          end

          session.delete(:trestle_user)
          @user = nil
        end

      protected
        def remember_me!
          Trestle.config.auth.remember.remember_me(user)
          cookies.signed[:trestle_remember_token] = Trestle.config.auth.remember.cookie(user)
        end

        def find_authenticated_user
          Trestle.config.auth.find_user(session[:trestle_user]) if session[:trestle_user]
        end

        def find_remembered_user
          return unless Trestle.config.auth.remember.enabled

          if token = cookies.signed[:trestle_remember_token]
            user = Trestle.config.auth.remember.authenticate(token)
            login!(user) if user
            user
          end
        end

        def login_params
          controller.params.require(:user).permit!
        end
      end
    end
  end
end
