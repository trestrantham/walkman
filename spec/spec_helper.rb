if ENV["TRAVIS"]
  require "coveralls"
  Coveralls.wear!
end

require "walkman"

Dir[File.expand_path("../support/*.rb", __FILE__)].each { |f| require f }

Walkman.config.log_level = :info

before do
  Walkman.echowrap.stub(:playlist_dynamic_create)
  Walkman.echowrap.stub(:playlist_dynamic_feedback)
  Walkman.echowrap.stub(:playlist_dynamic_next)
  Command.stub(:run)
end
