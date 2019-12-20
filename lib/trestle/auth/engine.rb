module Trestle
  module Auth
    class Engine < ::Rails::Engine
      config.assets.precompile << "trestle/auth.css" << "trestle/auth/userbox.css"

      config.before_initialize do
        Trestle::Engine.paths["app/helpers"].concat(paths["app/helpers"].existent)
      end

      initializer :extensions do
        Trestle::ApplicationController.send(:include, Trestle::Auth::ControllerMethods)
      end
    end
  end
end
