require "thor"
require "drb"
require "colorize"

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
      response = server.run_command(:player_stop)
      puts response unless response.empty?

      server.stop_server
    end

    # controls tasks

    desc "play", "plays the current playlist"
    def play
      response = server.run_command(:play)
      puts response unless response.empty?
    end

    desc "stop", "stops playing music"
    def stop
      response = server.run_command(:stop)
      puts response unless response.empty?
    end

    desc "next", "plays the next song in the current playlist"
    def next
      response = server.run_command(:next)
      puts response unless response.empty?
    end

    desc "now_playing", "shows the song that's currently playing"
    def now_playing
      response = server.run_command(:now_playing)
      puts response unless response.empty?
    end

    desc "up_next", "shows the next songs on the current playlist"
    def up_next
      response = server.run_command(:up_next)
      puts response unless response.empty?
    end

    desc "play_artist ARTIST", "plays songs from the given artist"
    def play_artist(*artist)
      artist = artist.join(" ")
      response = server.run_command(:artist, { artist: artist })
      puts response unless response.empty?
    end

    desc "play_artist_radio ARTIST", "plays music like the given artist"
    def play_artist_radio(*artist)
      artist = artist.join(" ")
      response = server.run_command(:artist_radio, { artist: artist })
      puts response unless response.empty?
    end

    desc "like", "plays more music like the current song"
    def like
      response = server.run_command(:like)
      puts response unless response.empty?
    end

    no_tasks do
      def stop_server
        DRb.stop_service
      end

      def server
        @server ||= DRbObject.new_with_uri(Walkman.config.drb_uri)
      end

      def run_command(command, options = {})
        case command
        when :player_stop  then Walkman::Commands::Player.stop
        when :play         then Walkman::Commands::Controls.play
        when :stop         then Walkman::Commands::Controls.stop
        when :next         then Walkman::Commands::Controls.next
        when :up_next      then Walkman::Commands::Information.up_next
        when :now_playing  then Walkman::Commands::Information.now_playing
        when :artist       then Walkman::Commands::Queueing.artist(options[:artist])
        when :artist_radio then Walkman::Commands::Queueing.artist_radio(options[:artist])
        when :like         then Walkman::Commands::Playlist.like
        end
      end
    end
  end
end
