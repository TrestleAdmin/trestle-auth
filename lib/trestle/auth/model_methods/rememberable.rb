module Trestle
  module Auth
    module ModelMethods
      module Rememberable
        extend ActiveSupport::Concern

        def remember_me!
          update(remember_token: SecureRandom.urlsafe_base64(15), remember_token_expires_at: Time.now + Trestle.config.auth.remember.for)
        end

        def forget_me!
          update(remember_token: nil, remember_token_expires_at: nil)
        end

        def remember_token_expired?
          remember_token_expires_at.nil? || Time.now > remember_token_expires_at
        end

        module ClassMethods
          def authenticate_with_remember_token(token)
            user = find_by(remember_token: token)
            user if user && !user.remember_token_expired?
          end
        end
      end
    end
  end
end
