module Trestle
  module Auth
    class Configuration
      require_relative "configuration/rememberable"
      require_relative "configuration/warden"

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

      option :human_attribute_name, ->(field) {
        model = Trestle.config.auth.user_class rescue nil

        if model && model.respond_to?(:human_attribute_name)
          model.human_attribute_name(field)
        else
          field.to_s.humanize
        end
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

      option :enable_login, true
      option :enable_logout, true

      option :login_url, -> { login_url }, evaluate: false

      option :redirect_on_login, -> { Trestle.config.path }, evaluate: false
      option :redirect_on_logout, -> { login_url }, evaluate: false
      option :redirect_on_access_denied, -> {
        authorized?(:index, root_authorization_target) ? admin.path(:index) : Trestle.config.root
      }, evaluate: false

      option :logo

      option :remember, Rememberable.new

      option :backend, Backends::Basic

      def backend=(backend)
        assign(:backend, Backends.lookup(backend))
      end

      option :warden, Warden.new
    end
  end
end
