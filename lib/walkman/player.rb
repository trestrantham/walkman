require "singleton"

module Walkman
  class Player
    include Singleton

    attr_accessor :current_song, :playing

    SERVICES = [Walkman::Services::Rdio]

    def initialize
      @current_song = nil
      @playing = false
      @running = false
    end

    def services
      @services ||= begin
        Hash[SERVICES.map { |service| [service.name, service.new] }]
      end
    end

    def startup
      services.each do |key, service|
        service.startup
      end

      @running = true

      @playlist_thread = Thread.fork do
        current_loop_song = nil
        last_loop_song = nil

        while @running
          if @playing
            current_loop_song = @current_song

            if current_loop_song.nil?
              self.next
            elsif !last_loop_song.nil? && current_loop_song != last_loop_song
              stop
              current_loop_song = nil
              @playing = true # have to reset this due to calling stop
            elsif last_loop_song.nil?
              play_song(current_loop_song)
            end

            last_loop_song = current_loop_song
          end

          sleep 0.1
        end
      end
    end

    def shutdown
      @running = false
      @playlist_thread.join if @playlist_thread

      services.each do |key, service|
        service.shutdown
      end
    end

    def play
      @playing = true
    end

    def stop
      @playing = false

      services.each do |key, service|
        service.stop
      end
    end

    def next
      if @current_song = playlist.next
        @playing = true
      else
        stop
      end
    end

    def playlist
      @playlist ||= Walkman::Playlist.new
    end

    def playlist=(playlist)
      @playlist = playlist
    end

    private

    def play_song(song)
      services[song.source_type].play(song.source_id)
    end
  end
end
