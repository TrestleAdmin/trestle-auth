module Trestle
  module Auth
    module Extensions
      module Toolbars
        module TableActionsBuilder
          delegate :authorized?, to: :@template

          def show
            super if authorized?(:show, instance)
          end

          def edit
            super if authorized?(:edit, instance)
          end

          def delete
            super if authorized?(:destroy, instance)
          end
        end
      end
    end
  end
end
