require "spec_helper"

describe Walkman::Song do
  let(:song) { Walkman::Song.new }

  it "responds to #source_type" do
    expect(song).to respond_to(:source_type)
  end

  it "responds to #source_id" do
    expect(song).to respond_to(:source_id)
  end
end
