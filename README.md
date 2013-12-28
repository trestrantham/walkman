# Walkman

[![Build Status](https://travis-ci.org/trestrantham/walkman.png?branch=master)](https://travis-ci.org/trestrantham/walkman)
[![Code Climate](https://codeclimate.com/github/trestrantham/walkman.png)](https://codeclimate.com/github/trestrantham/walkman)
[![Coverage Status](https://coveralls.io/repos/trestrantham/walkman/badge.png)](https://coveralls.io/r/trestrantham/walkman)
[![Dependency Status](https://gemnasium.com/trestrantham/walkman.png)](https://gemnasium.com/trestrantham/walkman)

Walkman puts you in control if your music.

## Install

```
gem install walkman
```

## Dependencies

Walkman relies on a few external services to do its magic. Currently, the
canonical source for music data comes from [Echo Nest](http://echonest.com) who
provides artist/album/song information as well as playlist generation and
seeding. Actual music streams are currently provided via [Rdio](http://rdio.com)
with support for [Spotify](http://spotify.com) and local file playback via
[MPD](http://musicpd.org) in the works.

### Echo Nest

1. [Sign up](https://developer.echonest.com/account/register) for an Echo Nest developer account
2. Grab the `api_key`, `consumer_key`, and `shared_secret`
3. Create a catalog (taste profile) to use as your base library and grab its `id` to use as `catalog_id`:

```
curl -F "api_key=<api_key>" -F "format=json" -F "type=general" -F "name=base_profile" "http://developer.echonest.com/api/v4/tasteprofile/create"
```

### Rdio

1. [Sign up](http://developer.rdio.com/member/register) for a Rdio developer account
2. [Generate](http://rdioconsole.appspot.com/#method=getPlaybackToken) a `playback_token` after logging in at [rdio.com](http://rdio.com).

### Config

Create a Walkman config file at `~/.walkman`:

```
log_level: debug # optional
server:
  host: localhost # optional
  port: 27001 # optional
echonest:
  api_key: APIKEY
  consumer_key: CONSUMERKEY
  shared_secret: SHAREDSECRET
  catalog_id: CATALOGID
rdio:
  player_url: http://localhost:4567/rdio # optional
  playback_token: PLAYBACKTOKEN
  browser_path: /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --no-process-singleton-dialog # optional
```

## Usage

```
Commands:
  walkman help [COMMAND]            # Describe available commands or one specific command
  walkman like                      # plays more music like the current song
  walkman next                      # plays the next song in the current playlist
  walkman now_playing               # shows the song that's currently playing
  walkman play                      # plays the current playlist
  walkman play_artist ARTIST        # plays songs from the given artist
  walkman play_artist_radio ARTIST  # plays music like the given artist
  walkman shutdown                  # stops the walkman server
  walkman skip COUNT                # skips the given amount of songs
  walkman start                     # starts the walkman server
  walkman stop                      # stops playing music
  walkman up_next                   # shows the next songs on the current playlist
```
