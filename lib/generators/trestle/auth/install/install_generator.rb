module Trestle
  module Auth
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        desc "Installs trestle-auth"

        argument :model, type: :string, default: "Administrator"

        class_option :devise, type: :boolean, default: false, desc: "Setup trestle-auth with Devise integration"

        source_root File.expand_path("../templates", __FILE__)

        def check_trestle_installed
          unless ::File.exist?("config/initializers/trestle.rb")
            raise Thor::Error, "The file config/initializers/trestle.rb does not appear to exist. Please run `trestle:install` first."
          end
        end

        def insert_configuration
          inject_into_file "config/initializers/trestle.rb", before: /^end/ do
            format_configuration(template_content(configuration_template))
          end
        end

        def generate_model
          generate "trestle:auth:model", model unless devise?
        end

        def generate_admin
          generate "trestle:auth:admin", model, ("--devise" if devise?)
        end

        def devise?
          options[:devise]
        end

        def configuration_template
          devise? ? "devise.rb.erb" : "basic.rb.erb"
        end

      private
        def format_configuration(source)
          "\n#{source.indent(2)}\n"
        end

        def template_content(path, options={})
          path = File.expand_path(find_in_source_paths(path.to_s))
          context = options.delete(:context) || instance_eval("binding")

          capturable_erb = CapturableERB.new(::File.binread(path), trim_mode: "-", eoutvar: "@output_buffer")

          content = capturable_erb.tap do |erb|
            erb.filename = path
          end.result(context)
        end
      end
    end
  end
end
