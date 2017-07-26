module Trestle
  module Auth
    module ModelMethods
      extend ActiveSupport::Concern
      extend ActiveSupport::Autoload

      autoload :Rememberable

      included do
        has_secure_password
      end

      module ClassMethods
        def authenticate(identifier, password)
          user = find_by(Trestle.config.auth.authenticate_with => identifier) || NullUser.new
          user.authenticate(password)
        end
      end
    end
  end
end
