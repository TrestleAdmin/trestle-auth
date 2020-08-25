module Trestle
  module Auth
    class DSL < Trestle::Builder
      target :adapter

      def initialize
        @adapter = Class.new(Trestle::Auth::BuiltinAdapter)
      end

      def scope(&block)
        @adapter.scope = block
      end

      def actions(*actions, &block)
        actions.each do |action|
          define_action(action, &block)
        end
      end

      def read!(&block)
        define_action("read!", &block)
      end

      def update!(&block)
        define_action("update!", &block)
      end

      def create!(&block)
        define_action("create!", &block)
      end

      def access!(&block)
        define_action("access!", &block)
      end

      def method_missing(method_name, *args, &block)
        if method_name[-1] == '?'
          action_name = method_name[0..-2]
          define_action(action_name, &block)
        else
          super
        end
      end

    private
      def define_action(action, &block)
        @adapter.actions[action.to_s] = block
      end
    end
  end
end
