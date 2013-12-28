require "spec_helper"

describe Walkman::Playlist do
  let(:playlist) { create(:playlist) }
  let(:song) { create(:song) }

  before do
    Walkman.echowrap.stub(:playlist_dynamic_feedback)
    playlist.session_id = "ABC123"
  end

  it "responds to #session_id" do
    expect(playlist).to respond_to(:session_id)
  end

  describe ".new" do
    it "initializes an empty queue" do
      expect(playlist.queue).to eq([])
    end

    it "initializes with a single song" do
      song_playlist = Walkman::Playlist.new(songs: song)

      expect(song_playlist.queue).to eq([song])
    end

    it "initializes with a multiple songs" do
      song2 = create(:song)
      songs_playlist = Walkman::Playlist.new(songs: [song, song2])

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

      expect(playlist.include?(song)).to eq(true)
      expect(playlist.queued?(song)).to eq(true)
    end

    it "returns false if the given song is not currently queued" do
      expect(playlist.include?(song)).to eq(false)
      expect(playlist.queued?(song)).to eq(false)
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
    it "adds multiple songs to the end of the queue" do
      songs = []

      3.times do
        songs << create(:song)
      end

      expect {
        playlist.add(songs)
      }.to change {
        playlist.queue.size
      }.from(0).to(3)
    end

    it "adds a song to the end of the queue" do
      3.times { playlist.add(create(:song)) }

      expect {
        playlist.add(song)
      }.to change {
        playlist.queue.size
      }.from(3).to(4)

      expect(playlist.queue.index(song)).to eq(3)
    end

    it "inserts a song into the given index" do
      3.times { playlist.add(create(:song)) }

      playlist.add(song, 0)

      expect(playlist.queue.index(song)).to eq(0)
    end

    it "ignores invalid indexes when adding a song" do
      3.times { playlist.add(create(:song)) }

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

  describe "#shuffle!" do
    it "changes the order of songs in the queue" do
      100.times { playlist.add(create(:song)) }

      expect {
        playlist.shuffle!
      }.to change {
        playlist.queue.first
      }
    end
  end

  describe "#next" do
    it "returns the next song from the playlist" do
      song2 = create(:song)

      playlist.add([song, song2])

      expect(playlist.next).to eq(song)
      expect(playlist.next).to eq(song2)
    end
  end

  describe "#size" do
    it "returns the size of the playlist queue" do
      3.times { playlist.add(create(:song)) }

      expect(playlist.size).to eq(3)
    end
  end

  describe "#feedback" do
    it "updates favorites" do
      args = { session_id: "ABC123", favorite_song: [song.echonest_song_id], favorite_artist: [song.echonest_artist_id] }

      expect(Walkman.echowrap).to receive(:playlist_dynamic_feedback).with(args)

      playlist.feedback(:favorite, song)
    end

    it "updates unplay counts" do
      args = { session_id: "ABC123", unplay_song: [song.echonest_song_id] }

      expect(Walkman.echowrap).to receive(:playlist_dynamic_feedback).with(args)

      playlist.feedback(:unplay, song)
    end

    it "updates skip counts" do
      args = { session_id: "ABC123", skip_song: [song.echonest_song_id] }

      expect(Walkman.echowrap).to receive(:playlist_dynamic_feedback).with(args)

      playlist.feedback(:skip, song)
    end
  end
end
