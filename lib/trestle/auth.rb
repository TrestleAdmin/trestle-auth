require_relative "auth/version"

require "trestle"

module Trestle
  module Auth
    extend ActiveSupport::Autoload

    require_relative "auth/admin"
    require_relative "auth/access_denied"
    require_relative "auth/backends"
    require_relative "auth/builder"
    require_relative "auth/configuration"
    require_relative "auth/constraint"
    require_relative "auth/model_methods"
    require_relative "auth/null_user"
    require_relative "auth/resource"
    require_relative "auth/toolbars"

    module Controller
      require_relative "auth/controller/authentication"
      require_relative "auth/controller/authorization"
      require_relative "auth/controller/locale"
      require_relative "auth/controller/time_zone"
    end

    require_relative "auth/controller_methods"

    autoload_under "adapters" do
      autoload :CanCanAdapter
    end
  end

  Configuration.option :auth, Auth::Configuration.new
end

require_relative "auth/engine" if defined?(Rails)
