require "echowrap"

require "walkman/config"
require "walkman/logger"

require "walkman/services/base"
require "walkman/services/rdio"
require "walkman/services/rdio/rdio_player"

require "walkman/player"
require "walkman/playlist"
require "walkman/song"

require "walkman/commands/controls"
require "walkman/commands/information"
require "walkman/commands/player"
require "walkman/commands/playlist"
require "walkman/commands/queueing"

require "walkman/cli"

module Walkman
  def self.echowrap
    @echowrap ||= Echowrap.configure do |config|
      config.api_key       = Walkman.config.echonest_api_key
      config.consumer_key  = Walkman.config.echonest_consumer_key
      config.shared_secret = Walkman.config.echonest_shared_secret
    end
  end
end
