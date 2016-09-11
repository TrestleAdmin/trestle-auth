module Trestle
  module Auth
    class Configuration
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
    end
  end
end
