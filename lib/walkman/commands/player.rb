module Walkman
  module Commands
    module Player
      def self.start
        Walkman::Player.instance.startup
      end

      def self.stop
        Walkman::Player.instance.shutdown
      end
    end
  end
end
