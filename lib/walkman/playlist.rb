module Walkman
  class Playlist
    attr_accessor :session_id

    def initialize(options = {})
      songs = options.delete(:songs) || []
      @queue = [songs].flatten # can add one or more Songs
      @auto_queue = options.delete(:auto_queue) || false

      if echonest_playlist = echonest_playlist_create(options)
        @session_id = echonest_playlist.session_id
      end

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
      songs = [songs].flatten
      song = songs.pop # the last song skipped

      # skip and unplay songs so our echonest catalog/profile stays true
      skip(songs)

      if @auto_queue && size <= 5
        auto_queue(5) if @session_id
      end

      song
    end

    def size
      @queue.size
    end

    def unplay(songs)
      songs = [songs].flatten # one or more

      songs.each do |song|
        echonest_playlist_feedback({ unplay_song: song.echonest_song_id })
      end
    end

    def skip(songs)
      songs = [songs].flatten # one or more

      songs.each do |song|
        echonest_playlist_feedback({ skip_song: song.echonest_song_id, unplay_song: song.echonest_song_id })
      end
    end

    def favorite(songs)
      songs = [songs].flatten # one or more

      songs.each do |song|
        echonest_playlist_feedback({ favorite_song: song.echonest_song_id, favorite_artist: song.echonest_artist_id })
      end
    end

    private

    def echonest_playlist_create(options = {})
      return nil unless options.keys.include?(:type)

      options[:bucket] = ["id:rdio-US", "tracks"]
      options[:seed_catalog] = Walkman.config.echonest_catalog_id
      options[:session_catalog] = Walkman.config.echonest_catalog_id

      if remote_playlist = Walkman.echowrap.playlist_dynamic_create(options)
        remote_playlist
      else
        nil
      end
    end

    def echonest_playlist_feedback(args = {})
      args[:session_id] = @session_id

      Walkman.echowrap.playlist_dynamic_feedback(args)
    end

    def auto_queue(count = 5)
      return 0 unless @session_id

      result = Walkman.echowrap.playlist_dynamic_next(session_id: @session_id, results: count)
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
                                   echonest_artist_id: song.artist_id,
                                   echonest_song_id: song.id)
      end

      add(songs)
      songs.count
    end
  end
end
