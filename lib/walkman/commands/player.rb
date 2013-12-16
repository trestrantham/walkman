module Walkman
  module Commands
    module Player
      def self.start
        Walkman::Player.startup
      end

      def self.stop
        Walkman::Player.shutdown
      end

      # def pause
      #   Player.pause
      # end

      # def stop
      #   Player.stop
      # end

      # def next
      #   Player.next
      # end

      # def previous
      #   Player.previous
      # end
    end
  end
end
