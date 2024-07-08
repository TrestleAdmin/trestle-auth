module Trestle
  module Auth
    class Engine < ::Rails::Engine
      initializer "trestle.sprockets" do |app|
        # Sprockets manifest
        config.assets.precompile << "trestle/auth/manifest.js"
      end if defined?(Sprockets)

      initializer "trestle.propshaft" do |app|
        app.config.assets.excluded_paths << root.join("app/assets/sprockets")
      end if defined?(Propshaft)

      config.before_initialize do
        Trestle::Engine.paths["app/helpers"].concat(paths["app/helpers"].existent)
      end

      config.to_prepare do
        Trestle::ApplicationController.send(:include, Trestle::Auth::ControllerMethods)
      end
    end
  end
end
