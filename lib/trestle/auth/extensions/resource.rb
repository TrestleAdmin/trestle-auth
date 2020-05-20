module Trestle
  module Auth
    module Extensions
      module Resource
        extend ActiveSupport::Concern

        included do
          # Include custom #collection method on Resource instance
          prepend ResourceCollection

          # Include custom #collection method on Resource class
          singleton_class.send(:prepend, ResourceCollection)
        end

        def default_authorization_target
          model
        end
      end
    end
  end
end
