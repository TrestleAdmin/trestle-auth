module Trestle
  module Auth
    module ControllerMethods
      extend ActiveSupport::Concern

      include Controller::Authentication
      include Controller::Authorization
      include Controller::Locale
      include Controller::TimeZone
    end
  end
end
