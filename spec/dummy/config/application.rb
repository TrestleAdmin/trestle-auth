require_relative 'boot'

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "active_job/railtie"
# require "active_storage/engine"
# require "action_mailer/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for current Rails version.
    case Rails.version.split(".").first(2).join(".")
    when '6.0'
      config.load_defaults 6.0
    when '5.2'
      config.load_defaults 5.2
    when '5.1'
      config.load_defaults 5.1
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
