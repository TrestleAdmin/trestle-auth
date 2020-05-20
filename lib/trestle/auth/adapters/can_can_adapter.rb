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

      def initialize(admin, user)
        @admin, @user = admin, user
        @ability = ability_class.new(user)
      end

      def authorized?(action, target=nil)
        @ability.can?(action, target)
      end

      def scope(collection)
        collection.accessible_by(@ability)
      end
    end
  end
end
