module Walkman
  class Playlist
    attr_accessor :session_id

    def initialize(opts = {})
      songs = opts.delete(:songs) || []
      @queue = [songs].flatten # can add one or more Songs
      @auto_queue = opts.delete(:auto_queue) || false

      type = opts.delete(:type)
      artist = opts.delete(:artist)

      if type && artist
        @session_id = remote_playlist(type, artist).session_id
      end
    end

    def queue
      @queue
    end

    def clear
      @queue = []
    end

    def include?(song)
      @queue.include?(song)
    end
    alias_method :queued?, :include?

    def shuffle
      @queue.shuffle!
    end

    def add(songs, position = -1)
      index = @queue.size
      index = [position, index].min if position >= 0
      @queue.insert(index, songs).flatten!
    end

    def remove(song)
      @queue.delete_if { |s| s == song }
    end

    def next
      @queue.shift
    end

    private

    def remote_playlist(type, artist)
      bucket = ["id:rdio-US", "tracks"] 
      Walkman.echowrap.playlist_dynamic_create(type: type, artist: artist, bucket: bucket)
    end
  end
end
