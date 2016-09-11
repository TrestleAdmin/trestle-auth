module Trestle
  module Auth
    class NullUser
      def authenticate(password)
        false
      end
    end
  end
end
