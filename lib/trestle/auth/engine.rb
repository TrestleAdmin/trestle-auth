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
        Trestle::ResourceController.send(:include, Trestle::Auth::Extensions::ResourceController)
      end

      initializer :extensions do
        Trestle::Admin.send(:include, Trestle::Auth::Extensions::Admin)
        Trestle::Admin::Builder.send(:include, Trestle::Auth::Extensions::Admin::Builder)

        Trestle::Resource.send(:include, Trestle::Auth::Extensions::Resource)

        Trestle::Resource::Toolbar::Builder.send(:prepend, Trestle::Auth::Extensions::Toolbars::ResourceBuilder)
        Trestle::Table::ActionsColumn::ActionsBuilder.send(:prepend, Trestle::Auth::Extensions::Toolbars::TableActionsBuilder)

        Trestle::Navigation::Item.send(:prepend, Trestle::Auth::Extensions::Navigation::Item)

        Trestle::Form::Field.send(:prepend, Trestle::Auth::Extensions::Form::Field)
      end
    end
  end
end
