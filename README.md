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
curl -F "api_key=<api_key>" -F "format=json" -F "type=general" -F "name=base_profile"
```

### Rdio

1. [Sign up](http://developer.rdio.com/member/register) for a Rdio developer account
2. [Generate](http://rdioconsole.appspot.com/#method=getPlaybackToken) a `playback_token` after logging in at [rdio.com](http://rdio.com).

### Config

Create a Walkman config file at `~/.walkman`:

```
echonest:
  api_key: ABCDEFGHIJKLMNOP
  consumer_key: abc123efg456hij789klm098nop765qr
  shared_secret: 4jh&kjhfg.@3kjfl987FJ3
  catalog_id: CACABCD1234567890Z
rdio:
  playback_token: GAlNi78J_____zlyYWs5ZG02N2pkaHlhcWsyOWJtYjkyN2xvY2FsaG9zdEbwl7EHvbylWSWFWYMZwfc=
```