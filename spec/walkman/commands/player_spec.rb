require "spec_helper"

describe Walkman::Commands::Player do
  let!(:player) { Walkman::Player.instance }

  describe ".start" do
    it "calls startup on the player" do
      expect(player).to receive(:startup)
      Walkman::Commands::Player.start
    end
  end

  describe ".stop" do
    it "calls shutdown on the player" do
      expect(player).to receive(:shutdown)
      Walkman::Commands::Player.stop
    end
  end
end
