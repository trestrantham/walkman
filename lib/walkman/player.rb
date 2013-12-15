require "singleton"
require "forwardable"

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
          self.next if @playing && @current_song.nil?
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
      Walkman.logger.info "Playing current song"
      @playing = true

      if @current_song
        services[@current_song.source_type].play(@current_song.source_id)
      end
    end

    def stop
      Walkman.logger.info "Stopping current song"
      @playing = false

      services.each do |key, service|
        service.stop
      end
    end

    def next
      Walkman.logger.info "Playing next song"

      stop if @playing
      @current_song = playlist.next
      play
    end

    # Forward instance methods to the class
    class << self
      extend Forwardable
      def_delegators :instance, *Walkman::Player.instance_methods(false)
    end
  end
end
