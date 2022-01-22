module Trestle
  module Auth
    class CanCanAdapter
      class << self
        attr_writer :ability_class

        def build(ability_class)
          Class.new(self).tap do |klass|
            klass.ability_class = ability_class
          end
        end

        def ability_class
          Auth.constantize(@ability_class)
        end
      end

      delegate :ability_class, to: :class

      def initialize(context)
        @context = context
      end

      def authorized?(action, target=nil)
        ability.can?(action, target)
      end

      def scope(collection)
        collection.accessible_by(ability)
      end

    protected
      def ability
        @context.send(:authorizer_cache)[ability_class] ||= ability_class.new(current_user)
      end

      def current_user
        @context.send(:current_user)
      end
    end
  end
end
