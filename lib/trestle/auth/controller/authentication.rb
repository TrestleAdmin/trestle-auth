module Trestle
  module Auth
    module Controller
      module Authentication
        extend ActiveSupport::Concern

        included do
          helper_method :current_user, :logged_in?
          before_action :require_authenticated_user
        end

      protected
        def current_user
          @current_user ||= find_authenticated_user
        end

        def login!(user)
          session[:trestle_user] = user.id
          @current_user = user
        end

        def logout!
          session.delete(:trestle_user)
          @current_user = nil
        end

        def logged_in?
          !!current_user
        end

        def store_location
          session[:trestle_return_to] = request.fullpath
        end

        def previous_location
          session.delete(:trestle_return_to)
        end

        def find_authenticated_user
          Trestle.config.auth.find_user(session[:trestle_user]) if session[:trestle_user]
        end

        def require_authenticated_user
          logged_in? || login_required!
        end

        def login_required!
          store_location
          redirect_to trestle.login_url
          false
        end
      end
    end
  end
end
