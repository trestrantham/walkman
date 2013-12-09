Gem.find_files("walkman/service/**/*.rb").each { |path| require path }

require "walkman/player"
require "walkman/playlist"
require "walkman/song"
