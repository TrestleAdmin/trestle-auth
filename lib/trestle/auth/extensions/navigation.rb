module Trestle
  module Auth
    module Extensions
      module Navigation
        module Item
          def visible?(context)
            return false unless authorized?(context)
            super
          end

          def authorized?(context)
            !admin || !admin.authorize? || admin.new(context).authorized?(:index)
          end
        end
      end
    end
  end
end
