module Trestle
  module Auth
    module Controller
      module Authorization
        extend ActiveSupport::Concern

        included do
          before_action :authorize, if: :authorize?
          rescue_from AccessDenied, with: :unauthorized!
        end

      protected
        def authorize
          unless admin.authorization_adapter.authorized?(action_name.to_sym, authorization_target)
            raise AccessDenied, action: action_name.to_sym, target: authorization_target
          end
        end

        def authorize?
          defined?(admin) && admin && admin.authorize?
        end

        def authorization_target
          nil
        end

        def unauthorized!(exception)
          flash[:error] = {
            title:   t("admin.flash.unauthorized.title", default: "Access Denied!"),
            message: t("admin.flash.unauthorized.message", default: "You are not authorized to access this page.", message: exception.message)
          }

          if admin.authorization_adapter.authorized?(:index, admin.model)
            redirect_to admin.path(:index)
          else
            redirect_to Trestle.config.root
          end
        end
      end
    end
  end
end
