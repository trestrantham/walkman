module Walkman
  module Services
    class Base
      def startup
        raise "Implement in Service"
      end

      def shutdown
        raise "Implement in Service"
      end

      def restart
        raise "Implement in Service"
      end

      def play(song)
        raise "Implement in Service"
      end

      def stop
        raise "Implement in Service"
      end
    end
  end
end
