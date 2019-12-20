module Trestle
  module Auth
    class Engine < ::Rails::Engine
      config.assets.precompile << "trestle/auth.css" << "trestle/auth/userbox.css"

      config.before_initialize do
        Trestle::Engine.paths["app/helpers"].concat(paths["app/helpers"].existent)
      end

      initializer :extensions do
        Trestle::Admin.send(:include, Trestle::Auth::Admin)
        Trestle::Admin::Builder.send(:include, Trestle::Auth::Builder)

        Trestle::Resource.send(:include, Trestle::Auth::Resource)
        Trestle::Resource::Controller.send(:include, Trestle::Auth::Resource::Controller)

        # Include base controller methods last to ensure that the callbacks from
        # Trestle::Resource::Controller callbacks have been initialized.
        Trestle::ApplicationController.send(:include, Trestle::Auth::ControllerMethods)
      end
    end
  end
end
