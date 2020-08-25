require_relative "auth/version"

require "trestle"

module Trestle
  module Auth
    require_relative "auth/access_denied"
    require_relative "auth/backends"
    require_relative "auth/configuration"
    require_relative "auth/constraint"
    require_relative "auth/model_methods"
    require_relative "auth/null_user"

    require_relative "auth/controller/authentication"
    require_relative "auth/controller/authorization"
    require_relative "auth/controller/locale"
    require_relative "auth/controller/time_zone"

    require_relative "auth/controller_methods"

    require_relative "auth/extensions/admin"
    require_relative "auth/extensions/form"
    require_relative "auth/extensions/navigation"
    require_relative "auth/extensions/resource"
    require_relative "auth/extensions/resource_collection"
    require_relative "auth/extensions/resource_controller"
    require_relative "auth/extensions/toolbars"

    require_relative "auth/adapters/builtin_adapter"
    require_relative "auth/adapters/can_can_adapter"
    require_relative "auth/adapters/pundit_adapter"

    require_relative "auth/dsl"

    def self.constantize(klass)
      if klass.is_a?(String)
        klass.safe_constantize
      elsif klass.respond_to?(:call)
        klass.call
      else
        klass
      end
    end
  end

  Configuration.option :auth, Auth::Configuration.new
end

require_relative "auth/engine" if defined?(Rails)
