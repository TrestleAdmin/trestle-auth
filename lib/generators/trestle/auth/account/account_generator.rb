module Trestle
  module Auth
    module Generators
      class AccountGenerator < ::Rails::Generators::Base
        desc "Creates a Trestle admin for managing the logged in user"

        argument :model, type: :string, default: "Administrator"

        class_option :devise, type: :boolean, default: false, desc: "Create admin for a Devise user model"

        source_root File.expand_path("../templates", __FILE__)

        def create_admin
          template "admin.rb.erb", "app/admin/auth/account_admin.rb"
        end

        def devise?
          options[:devise]
        end

      protected
        def parameter_name
          singular_name
        end

        def singular_name
          model.demodulize.underscore
        end
      end
    end
  end
end
