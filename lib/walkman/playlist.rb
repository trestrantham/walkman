module Walkman
  class Playlist
    attr_accessor :session_id

    def initialize(options = {})
      type = options.delete(:type)
      artist = options.delete(:artist)
      songs = options.delete(:songs) || []

      @queue = [songs].flatten # can add one or more Songs
      @auto_queue = options.delete(:auto_queue) || false
      @session_id = remote_session_id(type: type, artist: artist) if type && artist

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

    def next(count = 1)
      # if the playlist is not empty, we can get one or more
      # songs back so we need to make sure we get the last one
      songs = @queue.shift(count)
      song = [songs].flatten.last

      if @auto_queue && size <= 5
        auto_queue(5) if @session_id
      end

      song
    end

    def size
      @queue.size
    end

    private

    def remote_session_id(options = {})
      artist = options.fetch(:artist)
      type = options.fetch(:type)
      bucket = ["id:rdio-US", "tracks"]

      remote_playlist = Walkman.echowrap.playlist_dynamic_create(type: type,
                                                                 artist: artist,
                                                                 bucket: bucket,
                                                                 variety: Walkman.config.echonest_variety)

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
        # find the first track with a rdio foreign key
        track = song.tracks.find do |t|
          t.foreign_id && t.foreign_id.split(":")[0] == "rdio-US"
        end

        next unless track

        songs << Walkman::Song.new(artist: song.artist_name,
                                   title: song.title,
                                   source_type: "Walkman::Services::Rdio",
                                   source_id: track.foreign_id.split(":").last,
                                   echonest_id: song.id)
      end

      add(songs)
      songs.count
    end
  end
end
