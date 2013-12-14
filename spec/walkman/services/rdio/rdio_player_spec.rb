require "spec_helper"
require "sinatra_helper"
require "walkman/services/rdio/rdio_player"

describe RdioPlayer do
  it "responds to /rdio/:source_id" do
    get "/rdio/t1234567"

    expect(last_response).to be_ok
    expect(last_response.body).to match(/track/)
    expect(last_response.body).to match(/artist/)
    expect(last_response.body).to match(/album/)
  end

  it "responds to /rdio/:source_id/done" do
    Walkman::Player.any_instance.stub(:current_song=)
    expect_any_instance_of(Walkman::Player).to receive(:current_song=)

    get "/rdio/t1234567/done"

    expect(last_response).to be_ok
    expect(last_response.body).to match(/Done/)
  end
end
