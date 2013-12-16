module Walkman
  module Commands
    module Information
      def self.now_playing
        if song = Walkman::Player.current_song
          "♫ Now playing #{song.title} by #{song.artist}"
        else
          "No music is playing."
        end
      end

      def self.up_next(num = 5)
        songs = Walkman::Player.playlist.take(num)

        songs.each do |song|
          "#{song.artist} - #{song.title}"
        end
      end
    end
  end
end
