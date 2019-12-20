module Trestle
  module Auth
    module Admin
      extend ActiveSupport::Concern

      included do
        singleton_class.attr_accessor :authorization_adapter
      end

      def authorization_adapter
        @authorization_adapter ||= self.class.authorization_adapter.new(self, current_user)
      end

      def current_user
        @context.send(:current_user)
      end

      def authorize?
        self.class.authorization_adapter
      end
    end
  end
end
