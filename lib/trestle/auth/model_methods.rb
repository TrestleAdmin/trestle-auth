module Trestle
  module Auth
    module ModelMethods
      extend ActiveSupport::Concern

      require_relative "model_methods/rememberable"

      included do
        has_secure_password
      end

      module ClassMethods
        def authenticate(identifier, password)
          user = find_by(Trestle.config.auth.authenticate_with => identifier) || NullUser.new
          user if user.authenticate(password)
        end
      end
    end
  end
end
