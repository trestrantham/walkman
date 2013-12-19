module Walkman
  module Commands
    module Queueing
      def self.play_artist(artist)
        playlist = Walkman::Playlist.new(type: "artist", artist: artist, auto_queue: true)
        Walkman::Player.instance.playlist = playlist

        if playlist.size > 0
          Walkman::Player.instance.next
        else
          "That artist couldn't be queued up"
        end
      end
    end
  end
end
