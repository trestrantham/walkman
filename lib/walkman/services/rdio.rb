module Walkman
  module Services
    class Rdio < Walkman::Services::Base
      def initialize
        @url = "http://localhost:4567/rdio"
        @app = '/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --no-process-singleton-dialog --incognito'
      end

      def startup
        @player_pid = fork { RdioPlayer.run! }
      end

      def shutdown
        Process.kill('KILL', @player_pid) if @player_pid
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
        launch_cmd = "#{@app} \"#{@url}/#{source_id}\" --user-data-data-dir=#{data_dir}"

        @browser_pid = fork { Command.run(launch_cmd) }
      end

      def quit_browser(source_id = "")
        find_cmd = "ps ax | grep \"#{@url}/#{source_id}\" | grep -v grep"
        kill_cmd = "kill $(ps ax | grep \"#{@url}/#{source_id}\" | grep -v grep | sed -e 's/^[ \t]*//' | cut -d ' ' -f 1)"

        Command.run(find_cmd).stdout.split("\n").size.times do
          Command.run(kill_cmd)
        end

        Process.kill('KILL', @browser_pid) if @browser_pid
      end
    end
  end
end
