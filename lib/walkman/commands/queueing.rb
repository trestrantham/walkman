module Walkman
  module Commands
    module Queueing
      def self.artist(artist)
        playlist = Walkman::Playlist.new(type: "artist", artist: artist, auto_queue: true)
        Walkman.player.playlist = playlist

        if playlist.size > 0
          Walkman.player.next
          output = ["♫".blue, "Playing songs by", artist.titleize.bold]
          output.flatten.join(" ")
        else
          "That artist couldn't be queued"
        end
      end

      def self.artist_radio(artist)
        playlist = Walkman::Playlist.new(type: "artist-radio", artist: artist, auto_queue: true)
        Walkman.player.playlist = playlist

        if playlist.size > 0
          Walkman.player.next
          output = ["♫".blue, "Playing music like", artist.titleize.bold]
          output.flatten.join(" ")
        else
          "Music like that artist couldn't be queued"
        end
      end
    end
  end
end
