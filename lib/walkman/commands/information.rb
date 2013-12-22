module Walkman
  module Commands
    module Information
      def self.now_playing
        if song = Walkman.player.current_song
          output = ["♫".blue, "Now playing"]
          output << [song.title.bold, "by", song.artist.bold]
          output.flatten.join(" ")
        else
          "No music is playing"
        end
      end

      def self.up_next(count = 5)
        songs = Walkman.player.playlist.queue.take(count)
        songs_string = ""

        songs.each do |song|
          songs_string += "#{song.artist} - #{song.title}\n"
        end

        songs_string
      end
    end
  end
end
