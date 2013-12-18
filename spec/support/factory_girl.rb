require "factory_girl"

RSpec.configure do |config|
  config.include(FactoryGirl::Syntax::Methods)
end

FactoryGirl.define do
  after(:stub) do |instance|
    instance.class.stub(:find).with(instance.id) { instance }
  end
end

FactoryGirl.find_definitions
