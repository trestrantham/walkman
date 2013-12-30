module Walkman
  module Commands
    module Queueing
      def self.artist(artist)
        playlist = self.queue("artist", artist: artist)

        if playlist.size > 0
          "♫ Playing songs by #{artist.titleize}"
        else
          "That artist couldn't be queued"
        end
      end

      def self.artist_radio(artist)
        playlist = self.queue("artist-radio", artist: artist)

        if playlist.size > 0
          "♫ Playing music like #{artist.titleize}"
        else
          "Music like that artist couldn't be queued"
        end
      end

      private

      def self.queue(type, args = {})
        args.merge!(type: type.to_s, auto_queue: true)

        playlist = Walkman::Playlist.new(args)
        Walkman.player.playlist = playlist

        if playlist.size > 0
          Walkman.player.next
        end

        playlist
      end
    end
  end
end
