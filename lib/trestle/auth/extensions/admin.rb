module Trestle
  module Auth
    module Extensions
      module Admin
        extend ActiveSupport::Concern

        included do
          singleton_class.attr_accessor :authorization_adapter
        end

        def authorization_adapter
          @authorization_adapter ||= self.class.authorization_adapter.new(self, current_user)
        end

        def current_user
          @context.send(:current_user)
        end

        def authorize?
          self.class.authorization_adapter
        end

        module Builder
          # def authorize(&block)
          # end

          def authorize_with(options_or_class)
            if options_or_class.is_a?(Hash)
              if ability = (options_or_class[:cancancan] || options_or_class[:cancan])
                authorize_with(CanCanAdapter.build(ability))
              elsif policy = options_or_class[:pundit]
                raise NotImplementError
              else
                raise ArgumentError, "unrecognized options"
              end
            else
              admin.authorization_adapter = options_or_class
            end
          end
        end
      end
    end
  end
end
