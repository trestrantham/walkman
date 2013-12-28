module Walkman
  module Commands
    module Playlist
      def self.like
        current_song = Walkman.player.current_song
        playlist = Walkman.player.playlist

        if current_song && playlist
          playlist.feedback(:favorite, current_song)
          "Awesome! I'll play more songs like this."
        else
          "No music is playing. Are you hearing things?"
        end
      end

      def self.shuffle!
        if playlist = Walkman.player.playlist
          playlist.shuffle!
          "Shaking things up a bit."
        else
          "No music is queued."
        end
      end
    end
  end
end
