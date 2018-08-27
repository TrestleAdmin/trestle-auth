module Trestle
  module Auth
    class Configuration
      extend ActiveSupport::Autoload

      autoload :Rememberable

      include Configurable

      option :user_class, -> { ::Administrator }
      option :user_scope, -> { Trestle.config.auth.user_class }
      option :user_admin

      option :authenticate_with, :email

      option :authenticate, ->(params) {
        scope = Trestle.config.auth.user_scope

        scope.authenticate(
          params[Trestle.config.auth.authenticate_with],
          params[:password]
        )
      }

      option :find_user, ->(id) {
        Trestle.config.auth.user_scope.find_by(id: id)
      }

      option :avatar, ->(user) {
        avatar { gravatar(user.email) }
      }, evaluate: false

      option :format_user_name, ->(user) {
        if user.respond_to?(:first_name) && user.respond_to?(:last_name)
          safe_join([user.first_name, content_tag(:strong, user.last_name)], " ")
        else
          display(user)
        end
      }, evaluate: false

      option :locale, ->(user) {
        user.locale if user.respond_to?(:locale)
      }, evaluate: false

      option :time_zone, ->(user) {
        user.time_zone if user.respond_to?(:time_zone)
      }, evaluate: false

      option :redirect_on_login, -> { Trestle.config.path }, evaluate: false
      option :redirect_on_logout, -> { login_url }, evaluate: false

      option :remember, Rememberable.new
    end
  end
end
