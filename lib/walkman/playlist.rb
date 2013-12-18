module Walkman
  class Playlist
    attr_accessor :session_id

    def initialize(opts = {})
      type = opts.delete(:type)
      artist = opts.delete(:artist)
      songs = opts.delete(:songs) || []

      @queue = [songs].flatten # can add one or more Songs
      @auto_queue = opts.delete(:auto_queue) || false
      @session_id = remote_session_id(type, artist) if type && artist
        
      if @auto_queue && @session_id
        auto_queue && self.next
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
      if @auto_queue && size <= 5
        auto_queue(5) if @session_id
      end

      @queue.shift
    end

    def size
      @queue.size
    end

    private

    def remote_session_id(type, artist)
      bucket = ["id:rdio-US", "tracks"] 
      remote_playlist = Walkman.echowrap.playlist_dynamic_create(type: type,
                                                                 artist: artist,
                                                                 bucket: bucket)

      if remote_playlist
        remote_playlist.session_id
      else
        nil
      end
    end

    def auto_queue(num = 10)
      return 0 unless @session_id

      result = Walkman.echowrap.playlist_dynamic_next(session_id: @session_id, results: num)
      songs = []

      result.songs.each do |song|
        track = song.tracks.find do |t|
          t.foreign_id && t.foreign_id.split(":")[0] == "rdio-US"
        end

        next unless track

        songs << Walkman::Song.new(artist: song.artist_name,
                                   title: song.title,
                                   source_type: "Walkman::Services::Rdio",
                                   source_id: track.foreign_id.split(":").last)
      end

      add(songs)
      songs.count
    end
  end
end
