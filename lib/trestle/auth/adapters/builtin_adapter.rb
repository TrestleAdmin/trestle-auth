module Trestle
  module Auth
    class BuiltinAdapter
      class_attribute :actions
      class_attribute :scope

      def self.inherited(subclass)
        subclass.actions = {}
      end

      ACTION_MAPPINGS = {
        "index"  => "read!",
        "show"   => "read!",
        "edit"   => "update!",
        "update" => "update!",
        "new"    => "create!",
        "create" => "create!"
      }

      def initialize(admin, user)
        @admin, @user = admin, user
      end

      def authorized?(action, target=nil)
        if block = block_for(action)
          @admin.instance_exec(target, &block)
        else
          false
        end
      end

      def scope(collection)
        if self.class.scope
          @admin.instance_exec(collection, &self.class.scope)
        else
          collection
        end
      end

    private
      def block_for(action)
        block_for_action(action) ||
          block_for_action(ACTION_MAPPINGS[action.to_s]) ||
          block_for_action("access!")
      end

      def block_for_action(action)
        self.class.actions[action.to_s] if action
      end
    end
  end
end
