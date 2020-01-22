module Trestle
  module Auth
    module Extensions
      module Form
        module Field
          delegate :authorized?, to: :template

          def readonly?
            super || (builder.object && !authorized?(:edit, builder.object))
          end
        end
      end
    end
  end
end
