module Walkman
  module Commands
    module Playlist
      def self.like
        song = Walkman.player.current_song
        playlist = Walkman.player.playlist

        if song && playlist
          Echowrap.playlist_dynamic_steer(session_id: playlist.session_id, more_like_this: song.echonest_id)
          "Awesome! I'll play more songs like this."
        else
          "No music is playing. Are you hearing things?"
        end
      end
    end
  end
end
