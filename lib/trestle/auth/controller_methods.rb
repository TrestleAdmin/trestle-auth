module Trestle
  module Auth
    module ControllerMethods
      extend ActiveSupport::Concern

      included do
        helper_method :current_user, :logged_in?
        before_action :require_authenticated_user
      end

    protected
      def current_user
        @current_user ||= Trestle.config.auth.user_scope.find_by(id: session[:trestle_user]) if session[:trestle_user]
      end

      def login!(user)
        @current_user = user
        session[:trestle_user] = user.id
      end

      def logout!
        @current_user = nil
        session.delete(:trestle_user)
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
