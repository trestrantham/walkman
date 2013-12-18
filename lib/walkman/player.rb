require "singleton"

module Walkman
  class Player
    include Singleton

    attr_accessor :playlist, :current_song, :playing

    SERVICES = [Walkman::Services::Rdio]

    def initialize
      Walkman.logger.debug "Initalizing player"

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
      Walkman.logger.info "Starting services"

      services.each do |key, service|
        service.startup
      end

      @running = true

      @playlist_thread = Thread.fork do
        Walkman.logger.debug "Starting main play loop"

        while @running
          if @playing && @current_song.nil?
            play if self.next
          end

          sleep 0.1
        end

        Walkman.logger.debug "Stopping main play loop"
      end
    end

    def shutdown
      Walkman.logger.info "Stopping services"
      @running = false
      @playlist_thread.join

      services.each do |key, service|
        service.shutdown
      end
    end

    def play
      @playing = true

      if @current_song
        Walkman.logger.info "Playing current song"

        services[@current_song.source_type].play(@current_song.source_id)
      end
    end

    def stop
      return if @current_song.nil?

      Walkman.logger.info "Stopping current song"

      @playing = false
      @current_song = nil

      services.each do |key, service|
        service.stop
      end
    end

    def next
      stop if @playing

      @current_song = playlist.next
    end
  end
end
