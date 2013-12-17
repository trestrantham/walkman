module Walkman
  module Commands
    module Queueing
      def self.play_artist(artist)
        playlist = Walkman::Playlist.new(type: "artist", artist: artist)
        Walkman::Player.instance.playlist = playlist
      end
    end
  end
end
