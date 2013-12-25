module Walkman
  class Playlist
    attr_accessor :session_id
    attr_reader   :queue

    def initialize(options = {})
      songs = options.delete(:songs) || []
      @queue = [songs].flatten # can add one or more Songs
      @auto_queue = options.delete(:auto_queue) || false

      if echonest_playlist = echonest_playlist_create(options)
        @session_id = echonest_playlist.session_id
      end

      if @auto_queue && @session_id
        auto_queue
        self.next
      end
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
      feedback([:skip, :unplay], songs) unless songs.empty?

      if @auto_queue && size <= 5
        auto_queue(5) if @session_id
      end

      song
    end

    def size
      @queue.size
    end

    def feedback(types, songs)
      songs    = [songs].flatten # one or more
      types    = [types].flatten # one or more
      song_ids = songs.map(&:echonest_song_id)
      args     = { session_id: @session_id }

      if types.include?(:favorite)
        args[:favorite_song] = song_ids
        args[:favorite_artist] = songs.map(&:echonest_artist_id)
      end

      args[:unplay_song] = song_ids if types.include?(:unplay)
      args[:skip_song] = song_ids if types.include?(:skip)

      Walkman.echowrap.playlist_dynamic_feedback(args)
    end

    private

    def echonest_playlist_create(args = {})
      return nil unless args.keys.include?(:type)

      args[:bucket] = ["id:rdio-US", "tracks"]
      args[:seed_catalog] = Walkman.config.echonest_catalog_id
      args[:session_catalog] = Walkman.config.echonest_catalog_id

      if remote_playlist = Walkman.echowrap.playlist_dynamic_create(args)
        remote_playlist
      else
        nil
      end
    end

    def auto_queue(count = 5)
      return 0 unless @session_id

      result = Walkman.echowrap.playlist_dynamic_next(session_id: @session_id, results: count)
      songs = parse_remote_songs(result.songs)
      add(songs)
    end

    def parse_remote_songs(remote_songs)
      songs = []

      remote_songs.each do |song|
        # find the first track with a rdio foreign key
        if track = song.tracks.find { |t| t.foreign_id.to_s.split(":")[0] == "rdio-US" }
          songs << Walkman::Song.new(artist: song.artist_name,
                                    title: song.title,
                                    source_type: "Walkman::Services::Rdio",
                                    source_id: track.foreign_id.split(":").last,
                                    echonest_artist_id: song.artist_id,
                                    echonest_song_id: song.id)
        end
      end

      songs
    end
  end
end
