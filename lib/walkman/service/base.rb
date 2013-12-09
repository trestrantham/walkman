module Walkman
  module Service
    class Base
      def startup
        raise("Implement in Player")
      end

      def shutdown
        raise("Implement in Player")
      end

      def restart
        raise("Implement in Player")
      end

      def play(song)
        raise("Implement in Player")
      end

      def stop
        raise("Implement in Player")
      end

      protected

      def ps_count?(val)
        `ps aux | grep "#{val}" | grep -v grep | wc -l | tr -d ' '`.chomp != "0"
      end
    end
  end
end
