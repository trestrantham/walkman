require "singleton"
require "forwardable"

module Walkman
  class Player
    include Singleton

    attr_accessor :playlist, :current_song, :playing

    SERVICES = [Walkman::Services::Rdio]

    def initialize
      @current_song = nil
      @playing = false
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

      @playlist_thread = Thread.fork do
        while true
          self.next if @playing && @current_song.nil?

          sleep 0.5
        end
      end
    end

    def shutdown
      @playlist_thread.terminate

      services.each do |key, service|
        service.shutdown
      end
    end

    def play
      @playing = true

      if @current_song
        services[@current_song.source_type].play(@current_song.source_id)
      end
    end

    def stop
      @playing = false

      services.each do |key, service|
        service.stop
      end
    end

    def next
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
