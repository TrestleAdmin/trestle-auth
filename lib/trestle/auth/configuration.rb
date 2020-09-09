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

      option :redirect_on_login, -> { Trestle.config.root }, evaluate: false
      option :redirect_on_logout, -> { login_url }, evaluate: false

      option :redirect_on_access_denied, -> {
        if authorized?(:index)
          admin.path(:index)
        else
          default_admin = Trestle.admins.values.find { |admin|
            admin.new(self).authorized?(:index)
          }

          default_admin ? default_admin.path : Trestle.config.root
        end
      }, evaluate: false

      option :logo

      option :remember, Rememberable.new

      option :backend, Backends::Basic

      def backend=(backend)
        assign(:backend, Backends.lookup(backend))
      end

      option :authorization_adapter

      def authorize_with(options_or_class)
        if options_or_class.is_a?(Hash)
          if ability = (options_or_class[:cancancan] || options_or_class[:cancan])
            authorize_with(CanCanAdapter.build(ability))
          elsif policy = options_or_class[:pundit]
            authorize_with(PunditAdapter.build(policy))
          else
            raise ArgumentError, "unrecognized options"
          end
        else
          assign(:authorization_adapter, options_or_class)
        end
      end

      def authorize(&block)
        authorize_with(DSL.build(&block))
      end

      option :warden, Warden.new
    end
  end
end
