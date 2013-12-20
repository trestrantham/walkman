module Walkman
  module Commands
    module Queueing
      def self.play_artist(artist)
        playlist = Walkman::Playlist.new(type: "artist", artist: artist, auto_queue: true)
        Walkman.player.playlist = playlist

        if playlist.size > 0
          Walkman.player.next
          "♫ Playing songs by #{artist}"
        else
          "That artist couldn't be queued up"
        end
      end
    end
  end
end
