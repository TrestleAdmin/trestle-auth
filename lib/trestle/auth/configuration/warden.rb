module Trestle
  module Auth
    class Configuration
      class Warden
        include Configurable

        option :scope
      end
    end
  end
end
