module Trestle
  module Auth
    module Controller
      module Authentication
        extend ActiveSupport::Concern

        included do
          helper_method :current_user, :logged_in?, :authentication_scope

          prepend_before_action :require_authenticated_user
          prepend_before_action :authenticate_user
        end

      protected
        def authentication_backend
          @_authentication_backend ||= Trestle.config.auth.backend.new(controller: self, request: request, session: session, cookies: cookies)
        end

        def current_user
          authentication_backend.user
        end

        def logged_in?
          authentication_backend.logged_in?
        end

        def authenticate_user
          authentication_backend.authenticate
        end

        def require_authenticated_user
          logged_in? || login_required!
        end

        def login!(user)
          authentication_backend.login!(user)
        end

        def logout!
          authentication_backend.logout!
        end

        def login_required!
          authentication_backend.store_location(request.fullpath)
          redirect_to instance_exec(&Trestle.config.auth.login_url)
          false
        end

        def authentication_scope
          authentication_backend.scope
        end
      end
    end
  end
end
