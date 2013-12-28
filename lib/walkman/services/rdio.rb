module Walkman
  module Services
    class Rdio < Walkman::Services::Base
      def startup
        Walkman.logger.debug "starting Rdio service"

        @player_thread = Thread.new do
          RdioPlayer.run!
        end
      end

      def shutdown
        Walkman.logger.debug "stopping Rdio service"

        quit_browser
        @player_thread.terminate if @player_thread
      end

      def restart
        shutdown
        startup
      end

      def play(source_id)
        quit_browser
        launch_browser(source_id)
      end

      def stop
        quit_browser
      end

      private

      def launch_browser(source_id)
        data_dir = "/tmp/walkman/chrome/#{rand(999999999999)}"
        launch_cmd = "#{Walkman.config.rdio_browser_path} \"#{Walkman.config.rdio_player_url}/#{source_id}\" --user-data-data-dir=#{data_dir}"

        @browser_pid = Process.fork do
          Signal.trap("TERM") { exit }

          Command.run(launch_cmd)
        end

        unless @browser_pid.nil?
          Walkman.logger.debug("detaching new browser process with pid #{@browser_pid}")

          Process.detach(@browser_pid)
        end
      end

      def quit_browser(source_id = "")
        Walkman.logger.debug("killing browser process")

        kill_cmd = "kill $(ps ax | grep \"#{Walkman.config.rdio_player_url}/#{source_id}\" | grep -v grep | sed -e 's/^[ \t]*//' | cut -d ' ' -f 1)"
        Command.run(kill_cmd)

        if @browser_pid
          Walkman.logger.debug("killing browser pid #{@browser_pid}")
          Process.kill("TERM", @browser_pid) rescue nil
        end
      end
    end
  end
end
