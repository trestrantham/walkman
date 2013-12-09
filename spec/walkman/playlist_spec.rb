require "spec_helper"

describe Walkman::Playlist do
  let(:playlist) { Walkman::Playlist.new }
  let(:song) { Walkman::Song.new }

  describe ".new" do
    it "initializes an empty queue" do
      expect(playlist.queue).to eq([])
    end

    it "initializes with a single song" do
      song_playlist = Walkman::Playlist.new(song)

      expect(song_playlist.queue).to eq([song])
    end

    it "initializes with a multiple songs" do
      song2 = Walkman::Song.new
      songs_playlist = Walkman::Playlist.new([song, song2])

      expect(songs_playlist.queue).to eq([song, song2])
    end
  end

  describe "#queue" do
    it "returns the current queue" do
      playlist.add(song)

      expect(playlist.queue).to eq([song])
    end
  end

  describe "#include?" do
    it "returns true if the given song is currently queued" do
      playlist.add(song)

      expect(playlist.include?(song)).to be_true
      expect(playlist.queued?(song)).to be_true
    end

    it "returns false if the given song is not currently queued" do
      expect(playlist.include?(song)).to be_false
      expect(playlist.queued?(song)).to be_false
    end
  end

  describe "#clear" do
    it "empties the current queue" do
      playlist.add(song)

      expect {
        playlist.clear
      }.to change {
        playlist.queue.count
      }.from(1).to(0)
    end
  end

  describe "#add" do
    it "adds a song to the end of the queue" do
      3.times { playlist.add(Walkman::Song.new) }

      expect {
        playlist.add(song)
      }.to change {
        playlist.queue.size
      }.from(3).to(4)

      expect(playlist.queue.index(song)).to eq(3)
    end

    it "inserts a song into the given index" do
      3.times { playlist.add(Walkman::Song.new) }

      playlist.add(song, 0)

      expect(playlist.queue.index(song)).to eq(0)
    end

    it "ignores invalide indexes when adding a song" do
      3.times { playlist.add(Walkman::Song.new) }

      playlist.add(song, 999)

      expect(playlist.queue.index(song)).to eq(3)
    end
  end

  describe "#remove" do
    it "removes the given song from the queue" do
      playlist.add(song)

      expect {
        playlist.remove(song)
      }.to change {
        playlist.queue.size
      }.from(1).to(0)
    end
  end

  describe "#shuffle" do
    it "changes the order of songs in the queue" do
      100.times { playlist.add(Walkman::Song.new) }

      expect {
        playlist.shuffle
      }.to change {
        playlist.queue.first
      }
    end
  end
end
