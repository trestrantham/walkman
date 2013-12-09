module Walkman
  module Service
    class Rdio < Walkman::Service::Base
      def initialize
        @url = "http://localhost:4567/rdio"
        @app = '/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --no-process-singleton-dialog --incognito'
      end

      def startup
        @pid = fork { RdioPlayer.run! }
      end

      def shutdown
        Process.kill('KILL', @pid)
      end

      def restart
        shutdown
        startup
      end

      def play(source_id)
        stop
        launch_browser(source_id)
      end

      def stop
        quit_browser
      end

      def quit_browser(source_id = "")
        `ps ax | grep "#{@url}/#{source_id}" | grep -v grep`.split("\n").size.times do
          `kill $(ps ax | grep "#{@url}/#{source_id}" | grep -v grep | sed -e 's/^[ \t]*//' | cut -d ' ' -f 1)`
        end
      end

      private

      def launch_browser(source_id)
        data_dir = "/tmp/walkman/chrome/#{rand(999999999999)}"
        cmd = "#{@app} \"#{@url}/#{source_id}\" --user-data-data-dir=#{data_dir}"

        pid = fork { Command.run(cmd) }
      end
    end
  end
end
