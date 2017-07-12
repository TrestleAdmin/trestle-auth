module Trestle
  module Auth
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        desc "Installs trestle-auth"

        argument :model, type: :string, default: "Administrator"

        def insert_configuration
          inject_into_file "config/initializers/trestle.rb", before: /^end/ do
            <<-RUBY.strip_heredoc.indent(2)

              # == Authentication Options
              #
              # Specify the user class to be used by trestle-auth.
              #
              config.auth.user_class = -> { #{model} }

              # Specify the scope for valid admin users.
              # Defaults to config.auth.user_class (unscoped).
              #
              # config.auth.user_scope = -> { User.where(admin: true) }

              # Specify the Trestle admin for managing administrator users.
              #
              config.auth.user_admin = -> { :"auth/#{model.underscore.pluralize}" }

              # Specify the parameter (along with a password) to be used to
              # authenticate an administrator. Defaults to :email.
              #
              # config.auth.authenticate_with = :login

              # Customize the method for authenticating a user given login parameters.
              # The block should return an instance of the auth user class, or nil.
              #
              # config.authenticate = ->(params) {
              #   User.authenticate(params[:login], params[:password])
              # }

              # Customize the rendering of user avatars. Can be disabled by setting to false.
              # Defaults to the Gravatar based on the user's email address.
              #
              # config.avatar = ->(user) {
              #   image_tag(user.avatar_url, alt: user.name)
              # }
            RUBY
          end
        end

        def generate_model
          generate "trestle:auth:model", model
        end

        def generate_admin
          generate "trestle:auth:admin", model
        end
      end
    end
  end
end
