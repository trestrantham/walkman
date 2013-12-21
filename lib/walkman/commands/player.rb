module Walkman
  module Commands
    module Player
      def self.start
        Walkman.player.startup
        "All systems go"
      end

      def self.stop
        Walkman.player.shutdown
        "Powering down"
      end
    end
  end
end
