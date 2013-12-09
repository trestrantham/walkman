require "spec_helper"

describe Walkman::Service::Rdio do
  let(:rdio) { Walkman::Service::Rdio.new }

  before do
    RdioPlayer.stub(:run!) { 1234 }
    Process.stub(:kill).with(anything()) { 1 }
  end

  describe "#startup" do
    it "starts RdioPlayer and returns pid" do
      expect(rdio).to receive(:fork) do |&block|
        expect(RdioPlayer).to receive(:run!)
        block.call
      end

      expect(rdio.startup).to be_a(Integer)
    end
  end

  describe "#shutdown" do
    it "kills RdioPlayer process" do
      pid = rdio.startup

      expect(Process).to receive(:kill).with("KILL", pid)

      rdio.shutdown
    end
  end

  describe "#restart" do
    it "stop and starts RdioPlayer" do
      rdio.startup

      expect(Process).to receive(:kill)
      expect(rdio).to receive(:fork) do |&block|
        expect(RdioPlayer).to receive(:run!)
        block.call
      end

      rdio.restart
    end
  end

  describe "#play" do
    it "stops any currently playing song" do
    end

    it "launches a new player browser with the given song" do
    end
  end

  describe "#stop" do
    it "stops any currently playing song" do
    end
  end
end
