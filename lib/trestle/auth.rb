require_relative "auth/version"

require "trestle"

module Trestle
  module Auth
    extend ActiveSupport::Autoload

    require_relative "auth/access_denied"
    require_relative "auth/backends"
    require_relative "auth/configuration"
    require_relative "auth/constraint"
    require_relative "auth/model_methods"
    require_relative "auth/null_user"

    module Controller
      require_relative "auth/controller/authentication"
      require_relative "auth/controller/authorization"
      require_relative "auth/controller/locale"
      require_relative "auth/controller/time_zone"
    end

    require_relative "auth/controller_methods"

    module Extensions
      require_relative "auth/extensions/admin"
      require_relative "auth/extensions/form"
      require_relative "auth/extensions/navigation"
      require_relative "auth/extensions/resource"
      require_relative "auth/extensions/resource_collection"
      require_relative "auth/extensions/resource_controller"
      require_relative "auth/extensions/toolbars"
    end

    autoload_under "adapters" do
      autoload :CanCanAdapter
    end
  end

  Configuration.option :auth, Auth::Configuration.new
end

require_relative "auth/engine" if defined?(Rails)
