module Trestle
  module Auth
    class Engine < ::Rails::Engine
      config.assets.precompile << "trestle/auth.css" << "trestle/auth.js" << "trestle/auth/userbox.scss"

      config.to_prepare do
        Trestle::ApplicationController.send(:include, Trestle::Auth::ControllerMethods)
      end
    end
  end
end
