module Trestle
  module Auth
    module Backends
      extend ActiveSupport::Autoload

      require_relative "backends/base"

      autoload :Basic
      autoload :Devise
      autoload :Warden

      def self.lookup(backend)
        case backend
        when Class
          backend
        else
          registry.fetch(backend) { raise ArgumentError, "Invalid authentication backend: #{backend.inspect}" }
        end
      end

      def self.registry
        @registry ||= {}
      end

      def self.register(name, klass)
        registry[name] = klass
      end

      register(:basic, Basic)
      register(:devise, Devise)
      register(:warden, Warden)
    end
  end
end
