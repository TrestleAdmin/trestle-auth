module Trestle
  module Auth
    module Backends
      class Devise < Warden
        # Authenticates a user from a login form request.
        # Devise requires that params authentication is explicitly enabled.
        def authenticate!
          request.env["devise.allow_params_authentication"] = true
          super
        end
      end
    end
  end
end
