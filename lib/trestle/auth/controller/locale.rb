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
          I18n.with_locale(Trestle.config.auth.locale.call(current_user) || I18n.default_locale) { yield }
        end
      end
    end
  end
end
