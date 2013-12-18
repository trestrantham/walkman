FactoryGirl.define do
  factory :echowrap_track, class: Echowrap::Track do
    skip_create

    ignore do
      catalog { "rdio-US" }
      duration { 300 }
      foreign_id { "rdio-US:track:t12345678" }
      foreign_release_id { "rdio-US:release:a123456" }
      id { "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890" }
    end

    initialize_with do
      Echowrap::Track.new(
        catalog: catalog,
        duration: duration,
        foreign_id: foreign_id,
        foreign_release_id: foreign_release_id,
        id: id
      )
    end
  end

  factory :echowrap_song, class: Echowrap::Song do
    skip_create

    ignore do
      artist_name { "Artist" }
      artist_foreign_ids { [{ catalog: "rdio-US", foreign_id: "rdio-US:artist:r12345" }] }
      title { "Title" }
      tracks { [create(:echowrap_track)] }
    end

    initialize_with do
      song = Echowrap::Song.new(
        artist_name: artist_name,
        artist_foreign_ids: artist_foreign_ids,
        title: title
      )

      [tracks].flatten.each { |track| song.tracks << track }
      song
    end
  end

  factory :echowrap_playlist, class: Echowrap::Playlist do
    skip_create

    ignore do
      code 0
      message { "Success" }
      version "4.2"
      session_id { "ABCDEFG123456789" }
      lookahead { [] }
      songs { [create(:echowrap_song)] }
    end

    trait :dynamic_create do
      initialize_with do
        Echowrap::Playlist.new(
          status: { version: version, code: code, message: message },
          session_id: session_id
        )
      end
    end

    trait :dynamic_next do
      initialize_with do
        playlist = Echowrap::Playlist.new(
          status: { version: version, code: code, message: message },
          lookahead: lookahead,
        )

        [songs].flatten.each { |song| playlist.songs << song }
        playlist
      end
    end
  end
end
