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
        launch_cmd = "#{Walkman.config.browser_app} \"#{Walkman.config.rdio_url}/#{source_id}\" --user-data-data-dir=#{data_dir}"

        @browser_pid = fork { Command.run(launch_cmd) }
      end

      def quit_browser(source_id = "")
        find_cmd = "ps ax | grep \"#{@url}/#{source_id}\" | grep -v grep"
        Walkman.logger.debug("killing browser process") 

        kill_cmd = "kill $(ps ax | grep \"#{Walkman.config.rdio_url}/#{source_id}\" | grep -v grep | sed -e 's/^[ \t]*//' | cut -d ' ' -f 1)"

        Command.run(find_cmd).stdout.split("\n").size.times do
          Command.run(kill_cmd)
        end

        Process.kill('KILL', @browser_pid) if @browser_pid
      end
    end
  end
end
