module Trestle
  module Auth
    module ControllerMethods
      extend ActiveSupport::Concern

      include Trestle::Auth::Controller::Authentication
      include Trestle::Auth::Controller::Authorization
      include Trestle::Auth::Controller::Locale
      include Trestle::Auth::Controller::TimeZone
    end
  end
end
