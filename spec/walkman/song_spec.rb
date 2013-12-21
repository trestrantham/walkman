require "spec_helper"

describe Walkman::Song do
  let(:song) { Walkman::Song.new }

  it "responds to #source_type" do
    expect(song).to respond_to(:source_type)
  end

  it "responds to #source_id" do
    expect(song).to respond_to(:source_id)
  end

  it "responds to #artist" do
    expect(song).to respond_to(:artist)
  end

  it "responds to #title" do
    expect(song).to respond_to(:title)
  end

  it "responds to #album" do
    expect(song).to respond_to(:album)
  end

  it "responds to #echonest_id" do
    expect(song).to respond_to(:echonest_id)
  end
end
