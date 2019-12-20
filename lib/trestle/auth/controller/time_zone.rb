module Trestle
  module Auth
    module Controller
      module TimeZone
        extend ActiveSupport::Concern

        included do
          around_action :set_time_zone, if: :logged_in? if Trestle.config.auth.time_zone
        end

      protected
        def set_time_zone
          Time.use_zone(Trestle.config.auth.time_zone.call(current_user) || Rails.application.config.time_zone) { yield }
        end
      end
    end
  end
end
