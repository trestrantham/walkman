require "sinatra"
require "command"

class RdioPlayer < Sinatra::Base
  get "/rdio/:song_id" do |song_id|
    erb :player, locals: { song_id: song_id }
  end

  get "/rdio/:song_id/done" do |song_id|
    Walkman::Player.services["Walkman::Service::Rdio"].stop
  end

  template :player do
<<-EOS
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"></script>
<script type="text/javascript">
  window.resizeTo(450, 450);

  var playback_token = 'GAlNi78J_____zlyYWs5ZG02N2pkaHlhcWsyOWJtYjkyN2xvY2FsaG9zdEbwl7EHvbylWSWFWYMZwfc=';
  var domain = 'localhost'
  var track_key = '<%= song_id %>';

  var apiswf = null;
  var playing = null;
  var done = false;

  $(document).ready(function() {
    // on page load use SWFObject to load the API swf into div#apiswf
    var flashvars = {
      'playbackToken': playback_token, // from token.js
      'domain': domain,                // from token.js
      'listener': 'callback_object'    // the global name of the object that will receive callbacks from the SWF
      };
    var params = {
      'allowScriptAccess': 'always'
    };
    var attributes = {};
    swfobject.embedSWF('http://www.rdio.com/api/swf/', // the location of the Rdio Playback API SWF
        'apiswf', // the ID of the element that will be replaced with the SWF
        1, 1, '9.0.0', 'expressInstall.swf', flashvars, params, attributes);
  });

  // the global callback object
  var callback_object = {};
  callback_object.ready = function ready(user) {
    apiswf = $('#apiswf').get(0);
    apiswf.rdio_play(track_key);
  }
  callback_object.playingTrackChanged = function playingTrackChanged(playingTrack, sourcePosition) {
    if(playing == null) {
      playing = playingTrack;
    }
    else if(playingTrack == null) {
      done = true
      $.get('/rdio/' + track_key + '/done');
    }

    if (playingTrack != null) {
      $('#track').text(playingTrack['name']);
      $('#album').text(playingTrack['album']);
      $('#artist').text(playingTrack['artist']);
      $('#art').attr('src', playingTrack['icon']);
    }
  }
</script>

<div id="apiswf"></div>
<dl>
  <dt>track</dt>
  <dd id="track"></dd>
  <dt>album</dt>
  <dd id="album"></dd>
  <dt>artist</dt>
  <dd id="artist"></dd>
  <dt>art</dt>
  <dd><img src="" id="art"></dd>
</dl>
EOS
  end
end
