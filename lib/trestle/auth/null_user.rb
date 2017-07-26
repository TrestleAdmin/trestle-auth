module Trestle
  module Auth
    class NullUser
      def authenticate(*)
        BCrypt::Password.new(self.class.password).is_password?("incorrect")
      end

      def self.password
        @password ||= BCrypt::Password.create("password", cost: BCrypt::Engine.cost)
      end
    end
  end
end
