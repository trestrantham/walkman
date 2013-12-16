module Walkman
  module Commands
    module Controls
      def self.play
        Walkman::Player.instance.play
      end

      def self.stop
        Walkman::Player.instance.stop
      end

      def self.next
        Walkman::Player.instance.next
      end
    end
  end
end
