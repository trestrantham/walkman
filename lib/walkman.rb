require "echowrap"

require_relative "walkman/config"
require_relative "walkman/logger"

require_relative "walkman/services/base"
require_relative "walkman/services/rdio"
require_relative "walkman/services/rdio/rdio_player"

require_relative "walkman/player"
require_relative "walkman/playlist"
require_relative "walkman/song"

require_relative "walkman/commands/controls"
require_relative "walkman/commands/information"
require_relative "walkman/commands/player"
require_relative "walkman/commands/playlist"
require_relative "walkman/commands/queueing"

require_relative "walkman/cli"

module Walkman
  def self.echowrap
    @echowrap ||= Echowrap.configure do |config|
      config.api_key       = Walkman.config.echonest_api_key
      config.consumer_key  = Walkman.config.echonest_consumer_key
      config.shared_secret = Walkman.config.echonest_shared_secret
    end
  end
end
