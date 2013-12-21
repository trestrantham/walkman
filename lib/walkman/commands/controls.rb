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

      def self.next
        Walkman.player.next
        song = Walkman.player.current_song

        output = ["♫".blue, "Skipping"]
        output << ["to", song.title.bold, "by", song.artist.bold] if song
        output.flatten.join(" ")
      end
    end
  end
end
