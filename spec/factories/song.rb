FactoryGirl.define do
  factory :song, class: Walkman::Song do
    skip_create

    album { "Album" }
    artist { "Artist" }
    source_id { "t12345678" }
    source_type { Walkman::Player::SERVICES.shuffle.first.to_s }
    title { "Title" }
  end
end
