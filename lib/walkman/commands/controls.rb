module Walkman
  module Commands
    module Controls
      def self.play
        Walkman.player.play

        if song = Walkman.player.current_song
          "♫ Playing #{song.title} by #{song.artist}"
        else
          "♫ We're playing but the queue is empty!"
        end
      end

      def self.stop
        Walkman.player.stop
        "Stopping walkman"
      end

      def self.next(count = 1)
        if current_song = Walkman.player.current_song
          Walkman.player.playlist.feedback(:skip, current_song)
        end

        Walkman.player.next(count)

        if song = Walkman.player.current_song
          "♫ Skipping to #{song.title} by #{song.artist}"
        else
          "No more songs in the queue. Stopping walkman"
        end
      end
      define_singleton_method(:skip) { |count| self.next(count) }
    end
  end
end
