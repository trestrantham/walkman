module Walkman
  module Commands
    module Information
      def self.now_playing
        if song = Walkman.player.current_song
          "♫ Now playing #{song.title} by #{song.artist}"
        else
          "No music is playing."
        end
      end

      def self.up_next(num = 5)
        songs = Walkman.player.playlist.queue.take(num)
        songs_string = ""

        songs.each do |song|
          songs_string += "#{song.artist} - #{song.title}\n"
        end

        songs_string
      end
    end
  end
end
