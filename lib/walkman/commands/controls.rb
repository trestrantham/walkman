module Walkman
  module Commands
    module Controls
      def self.play
        Walkman.player.play
        song = Walkman.player.current_song

        output = ["♫".blue, "Playing"]
        output << [song.title.bold, "by", song.artist.bold] if song
        output.flatten.join(" ")
      end

      def self.stop
        Walkman.player.stop
        ""
      end

      def self.next(count = 1)
        if current_song = Walkman.player.current_song
          Walkman.player.playlist.feedback(:skip, current_song)
        end

        Walkman.player.next(count)
        song = Walkman.player.current_song

        output = ["♫".blue, "Skipping"]
        output << ["to", song.title.bold, "by", song.artist.bold] if song
        output.flatten.join(" ")
      end
      define_singleton_method(:skip) { |count| self.next(count) }
    end
  end
end
