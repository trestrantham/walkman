module Walkman
  module Commands
    module Controls
      def self.play
        Walkman.player.play
      end

      def self.stop
        Walkman.player.stop
      end

      def self.next
        Walkman.player.next
      end
    end
  end
end
