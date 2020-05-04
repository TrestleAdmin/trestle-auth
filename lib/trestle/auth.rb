require_relative "auth/version"

require "trestle"

module Trestle
  module Auth
    require_relative "auth/backends"
    require_relative "auth/configuration"
    require_relative "auth/constraint"
    require_relative "auth/model_methods"
    require_relative "auth/null_user"

    module Controller
      require_relative "auth/controller/authentication"
      require_relative "auth/controller/locale"
      require_relative "auth/controller/time_zone"
    end

    require_relative "auth/controller_methods"
  end

  Configuration.option :auth, Auth::Configuration.new
end

require_relative "auth/engine" if defined?(Rails)
