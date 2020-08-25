module Trestle
  module Auth
    module Extensions
      module Admin
        extend ActiveSupport::Concern

        included do
          singleton_class.attr_writer :authorization_adapter
        end

        def authorized?(action, target=nil)
          authorization_adapter.authorized?(action, target || default_authorization_target)
        end

        def authorization_adapter
          @authorization_adapter ||= self.class.authorization_adapter.new(self, current_user)
        end

        def current_user
          @context.send(:current_user)
        end

        def default_authorization_target
          self
        end

        module ClassMethods
          def authorize?
            !!authorization_adapter
          end

          def authorization_adapter
            @authorization_adapter || Trestle.config.auth.authorization_adapter
          end
        end

        module Builder
          # Define an authorization block for the admin using the built-in DSL.
          def authorize(&block)
            authorize_with(DSL.build(&block))
          end

          # Specify the adapter class to use to authorize this admin.
          def authorize_with(options_or_class)
            if options_or_class.is_a?(Hash)
              if ability = (options_or_class[:cancancan] || options_or_class[:cancan])
                authorize_with(CanCanAdapter.build(ability))
              elsif policy = options_or_class[:pundit]
                authorize_with(PunditAdapter.build(policy))
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
