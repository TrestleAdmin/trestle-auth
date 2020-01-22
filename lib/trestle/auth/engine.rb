module Trestle
  module Auth
    class Engine < ::Rails::Engine
      config.assets.precompile << "trestle/auth.css" << "trestle/auth/userbox.css"

      config.before_initialize do
        Trestle::Engine.paths["app/helpers"].concat(paths["app/helpers"].existent)
      end

      initializer :extensions do
        Trestle::Admin.send(:include, Trestle::Auth::Extensions::Admin)
        Trestle::Admin::Builder.send(:include, Trestle::Auth::Extensions::Admin::Builder)

        Trestle::Resource.send(:include, Trestle::Auth::Extensions::Resource)
        Trestle::Resource::Controller.send(:include, Trestle::Auth::Extensions::Resource::Controller)

        Trestle::Resource::Toolbar::Builder.send(:prepend, Trestle::Auth::Extensions::Toolbars::ResourceBuilder)
        Trestle::Table::ActionsColumn::ActionsBuilder.send(:prepend, Trestle::Auth::Extensions::Toolbars::TableActionsBuilder)

        Trestle::Navigation::Item.send(:prepend, Trestle::Auth::Extensions::Navigation::Item)

        # Include base controller methods last to ensure that the callbacks from
        # Trestle::Resource::Controller callbacks have been initialized.
        Trestle::ApplicationController.send(:include, Trestle::Auth::ControllerMethods)
      end
    end
  end
end
