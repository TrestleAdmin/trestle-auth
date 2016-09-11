require "trestle/auth/version"

module Trestle
  module Auth
    extend ActiveSupport::Autoload

    autoload :Configuration
    autoload :ControllerMethods
    autoload :ModelMethods
    autoload :NullUser
  end

  Configuration.option :auth, Auth::Configuration.new
end

require "trestle/auth/engine" if defined?(Rails)
