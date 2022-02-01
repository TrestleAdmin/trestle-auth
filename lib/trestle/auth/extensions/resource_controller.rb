module Trestle
  module Auth
    module Extensions
      module ResourceController
        extend ActiveSupport::Concern

        included do
          # Redefine the before_action so that it is not called
          # until after the instance is initialized.
          before_action :authorize, if: :authorize?
        end

      protected
        def authorization_target
          instance || admin.model
        end
      end
    end
  end
end
