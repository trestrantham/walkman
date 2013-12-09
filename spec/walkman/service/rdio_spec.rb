require "spec_helper"

describe Walkman::Service::Rdio do
  let(:rdio) { Walkman::Service::Rdio.new }

  before do
    RdioPlayer.stub(:run!) { 1234 }
    Process.stub(:kill) { 1 }
    Command.stub(:run) { OpenStruct.new(stdout: "foo\nbar") }
    rdio.stub(:rand).with(anything) { 1234 }
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
    it "launches a new player browser with the given song" do
      expect(rdio).to receive(:fork) do |&block|
        expect(Command).to receive(:run).with("/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --no-process-singleton-dialog --incognito \"http://localhost:4567/rdio/t1234567\" --user-data-data-dir=/tmp/walkman/chrome/1234")
        block.call
      end

      rdio.play("t1234567")
    end
  end

  describe "#stop" do
    it "stops any currently playing song" do

      expect(Command).to receive(:run).with("ps ax | grep \"http://localhost:4567/rdio/\" | grep -v grep").at_least(2).times
      expect(Command).to receive(:run).with("kill $(ps ax | grep \"http://localhost:4567/rdio/\" | grep -v grep | sed -e 's/^[ \t]*//' | cut -d ' ' -f 1)").at_least(2).times
      expect(Process).to receive(:kill)

      rdio.play("t1234567")
      rdio.stop
    end
  end
end
