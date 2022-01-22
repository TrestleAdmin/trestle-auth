module Trestle
  module Auth
    class PunditAdapter
      class << self
        attr_writer :policy_class

        def build(policy_class)
          Class.new(self).tap do |klass|
            klass.policy_class = policy_class
          end
        end

        def policy_class
          Auth.constantize(@policy_class)
        end
      end

      delegate :policy_class, to: :class

      def initialize(context)
        @context = context
      end

      def authorized?(action, target=nil)
        query = "#{action}?"

        policy = policy_class.new(current_user, target)
        policy.respond_to?(query) && policy.public_send(query)
      end

      def scope(collection)
        if policy_scope = "#{policy_class}::Scope".safe_constantize
          policy_scope.new(current_user, collection).resolve
        else
          collection
        end
      end

    protected
      def current_user
        @context.send(:current_user)
      end
    end
  end
end
