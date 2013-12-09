if ENV["TRAVIS"]
  require "coveralls"
  Coveralls.wear!
end

require "walkman"

Dir[File.expand_path("../support/*.rb", __FILE__)].each { |f| require f }
