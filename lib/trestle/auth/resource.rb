module Trestle
  module Auth
    module Resource
      extend ActiveSupport::Concern

      included do
        # Include custom #collection method on Resource instance
        prepend Collection

        # Include custom #collection method on Resource class
        singleton_class.send(:prepend, Collection)
      end

      module Collection
        def collection(params={})
          scope = super

          if authorize? && authorization_adapter.respond_to?(:scope)
            scope = authorization_adapter.scope(scope)
          end

          scope
        end
      end

      module Controller
      protected
        def authorization_target
          instance || admin.model
        end

        def root_authorization_target
          admin.model
        end
      end
    end
  end
end
