module Trestle
  module Auth
    module Controller
      module Remember
        extend ActiveSupport::Concern

      protected
        def find_authenticated_user
          super || find_remembered_user
        end

        def logout!
          super
          forget_me!
        end

        def remember_me!
          return unless Trestle.config.auth.remember.enabled

          Trestle.config.auth.remember.remember_me(current_user)
          cookies.signed[:trestle_remember_token] = Trestle.config.auth.remember.cookie(current_user)
        end

        def forget_me!
          return unless Trestle.config.auth.remember.enabled

          Trestle.config.auth.remember.forget_me(current_user) if logged_in?
          cookies.delete(:trestle_remember_token)
        end

        def find_remembered_user
          return unless Trestle.config.auth.remember.enabled

          if token = cookies.signed[:trestle_remember_token]
            user = Trestle.config.auth.remember.authenticate(token)
            login!(user) if user
            user
          end
        end
      end
    end
  end
end
