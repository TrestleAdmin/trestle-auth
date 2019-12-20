module Trestle
  module Auth
    class AccessDenied < StandardError
      attr_reader :action, :target

      def initialize(options={})
        if options.is_a?(String)
          message = options
        else
          @action = options[:action]
          @target = options[:target]

          message = options.fetch(:message) { "access denied to #{action}" }
        end

        super(message)
      end
    end
  end
end
