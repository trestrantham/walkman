require "spec_helper"

describe Walkman::Commands::Controls do
  let!(:player) { Walkman.player }

  describe ".play" do
    it "calls play on the player" do
      expect(player).to receive(:play)
      Walkman::Commands::Controls.play
    end
  end

  describe ".stop" do
    it "calls stop on the player" do
      expect(player).to receive(:stop)
      Walkman::Commands::Controls.stop
    end
  end

  describe ".next" do
    it "calls next on the player" do
      expect(player).to receive(:next)
      Walkman::Commands::Controls.next
    end
  end
end
