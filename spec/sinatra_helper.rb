require "rack/test"

module SinatraSpecHelpers
  def app
    described_class
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include SinatraSpecHelpers
end
