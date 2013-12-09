require "spec_helper"

describe Walkman::Song do
  let(:song) { Walkman::Song.new }

  it "should respond to #source_type" do
    expect(song).to respond_to(:source_type)
  end

  it "should respond to #source_id" do
    expect(song).to respond_to(:source_id)
  end
end
