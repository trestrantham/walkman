require "spec_helper"

describe Walkman::Services::Rdio do
  let(:rdio) { Walkman::Services::Rdio.new }

  before do
    Process.stub(:kill) { 1 }
    rdio.stub(:rand).with(anything) { 1234 }

    # During tests, Process.fork seems to use an implicit return rather than
    # returning a pid. Since Command.run is the last statement in our Process.fork
    # block, we need to make sure it returns an int.
    Command.stub(:run) { 1 }
  end

  describe "#startup" do
    it "starts RdioPlayer" do
      expect(Thread).to receive(:new) do |&block|
        expect(RdioPlayer).to receive(:run!)
        block.call
      end

      rdio.startup
    end
  end

  describe "#shutdown" do
    it "terminates RdioPlayer thread" do
      my_thread = "foo"
      my_thread.stub(:terminate)
      rdio.instance_variable_set("@player_thread", my_thread)

      expect(my_thread).to receive(:terminate)

      rdio.shutdown
    end
  end

  describe "#restart" do
    it "stop and starts RdioPlayer" do
      expect(rdio).to receive(:shutdown)
      expect(rdio).to receive(:startup)

      rdio.restart
    end
  end

  describe "#play" do
    it "launches a new player browser with the given song" do
      rdio.instance_variable_set("@browser_pid", 123)

      expect(Process).to receive(:fork) do |&block|
        expect(Command).to receive(:run).with("/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --no-process-singleton-dialog \"http://localhost:4567/rdio/t1234567\" --user-data-data-dir=/tmp/walkman/chrome/1234")
        block.call
      end

      rdio.play("t1234567")
    end
  end

  describe "#stop" do
    it "stops any currently playing song" do
      expect(Command).to receive(:run).with("kill $(ps ax | grep \"http://localhost:4567/rdio/\" | grep -v grep | sed -e 's/^[ \t]*//' | cut -d ' ' -f 1)").at_least(2).times
      expect(Process).to receive(:kill)

      rdio.play("t1234567")
      rdio.stop
    end
  end
end
