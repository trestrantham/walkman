require "singleton"
require "forwardable"

module Walkman
  class Player
    include Singleton

    SERVICES = [Walkman::Service::Rdio]

    def services
      @services ||= begin
        Hash[SERVICES.map { |service| [service.name, service.new] }]
      end
    end

    def startup
      services.each do |key, service|
        service.startup
      end
    end

    def shutdown
      services.each do |key, service|
        service.shutdown
      end
    end

    def play(song)
      stop
      services[song.source_type].play(song.source_id)
    end

    def stop
      services.each do |key, service|
        service.stop
      end
    end

    # pause
    # next
    # prev

    # Forward instance methods to the class
    class << self
      extend Forwardable
      def_delegators :instance, *Walkman::Player.instance_methods(false)
    end
  end
end
