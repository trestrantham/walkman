require "thor"
require "drb"

module Walkman
  class CLI < Thor

    # server tasks

    desc "start", "starts the walkman server"
    option :daemon, type: :boolean, aliases: "-d"
    def start
      if options[:daemon]
        Process.daemon 
      else
        puts "Starting walkman server"
        puts "Run `walkman start -d` for daemon"
        puts "Ctrl-C to shutdown"

        trap("INT") do
          # calling this in a thread to get proper logging
          thread = Thread.new do
            shutdown
          end

          thread.join
        end
      end

      Walkman.logger.info("starting server")
      Walkman::Commands::Player.start

      DRb.start_service(Walkman.config.drb_uri, self)
      DRb.thread.join
    end

    desc "shutdown", "stops the walkman server"
    def shutdown
      server.run_command("Walkman::Commands::Player.stop")
      server.stop_server

      Walkman.logger.info("server stopped")
    end

    # controls tasks

    desc "play", "plays the current playlist"
    def play
      puts server.run_command("Walkman::Commands::Controls.play")
    end

    desc "stop", "stops playing music"
    def stop
      puts server.run_command("Walkman::Commands::Controls.stop")
    end

    desc "next", "plays the next song in the current playlist"
    def next
      puts server.run_command("Walkman::Commands::Controls.next")
    end

    desc "now_playing", "shows the song that's currently playing"
    def now_playing
      puts server.run_command("Walkman::Commands::Information.now_playing")
    end

    desc "up_next", "shows the next songs on the current playlist"
    def up_next
      puts server.run_command("Walkman::Commands::Information.up_next")
    end

    desc "play_artist ARTIST", "plays songs from the given artist"
    def play_artist(artist)
      puts server.run_command("Walkman::Commands::Queueing.play_artist(\"#{artist}\")")
    end

    no_tasks do
      def stop_server
        DRb.stop_service
      end

      def server
        @server ||= DRbObject.new_with_uri(Walkman.config.drb_uri)
      end

      def run_command(command)
        eval(command)
      end
    end
  end
end
