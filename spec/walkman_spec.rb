require "spec_helper"

describe Walkman do
  describe ".logger" do
    it "sets the log level according to config.log_level" do
      expect(Walkman.logger.level).to eq(Walkman.log_level(Walkman.config.log_level))
    end

    it "allows symbols when setting log level" do
      [:debug, :info, :warn, :error, :fatal, :unknown].each do |level|
        Walkman.class_variable_set("@@logger", nil) # reset logger
        Walkman.config.log_level = level

        expect(Walkman.logger.level).to eq(Walkman.log_level(level))
      end
    end
  end
end
