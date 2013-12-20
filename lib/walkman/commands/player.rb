module Walkman
  module Commands
    module Player
      def self.start
        Walkman.player.startup
      end

      def self.stop
        Walkman.player.shutdown
      end
    end
  end
end
