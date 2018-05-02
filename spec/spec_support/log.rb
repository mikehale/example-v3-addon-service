unless ENV["TEST_LOGS"] == "true"
  module Pliny
    module Log
      def log(_data, &block)
        yield if block
      end

      def log_with_default_context(_data, &block)
        yield if block
      end

      def log_without_context(_data, &block)
        yield if block
      end
    end
  end
end
