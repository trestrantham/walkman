require "spec_helper"

describe Walkman::Commands::Controls do
  let!(:player) { Walkman.player }

  before do
    Walkman.echowrap.stub(:playlist_dynamic_feedback)
  end

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

    it "updates the current song's skip count" do
      song = create(:song)
      player.current_song = song
      player.playlist = create(:playlist)

      expect(player.playlist).to receive(:feedback).with(:skip, song).once

      Walkman::Commands::Controls.next
    end

    it "updates the skipped songs' skip count" do
      songs = create_list(:song, 3)
      player.playlist = create(:playlist, songs: songs)

      expect(player.playlist).to receive(:feedback).with([:skip, :unplay], songs.take(2)).once

      Walkman::Commands::Controls.skip(3)
    end
  end
end
