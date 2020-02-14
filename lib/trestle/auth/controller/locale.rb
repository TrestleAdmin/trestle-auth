module Trestle
  module Auth
    module Controller
      module Locale
        extend ActiveSupport::Concern

        included do
          around_action :set_locale, if: :logged_in? if Trestle.config.auth.locale
        end

      protected
        def set_locale
          I18n.with_locale(instance_exec(current_user, &Trestle.config.auth.locale) || I18n.default_locale) { yield }
        end
      end
    end
  end
end
