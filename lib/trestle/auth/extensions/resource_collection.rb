module Trestle
  module Auth
    module Extensions
      module ResourceCollection
        def collection(params={})
          scope = super

          if authorize? && authorization_adapter.respond_to?(:scope)
            scope = authorization_adapter.scope(scope)
          end

          scope
        end
      end
    end
  end
end
