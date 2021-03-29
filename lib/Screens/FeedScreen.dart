import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nooble/Models/ArtistTopTracks.dart';
import 'package:nooble/Models/Audio.dart';
import 'package:nooble/Services/SpotifyAPI.dart';
import 'package:nooble/Widgets/ControlButtons.dart';
import 'package:nooble/Widgets/SeekBar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:nooble/constants.dart';
import 'package:spotify/spotify.dart' as Spotify;
import 'package:swipedetector/swipedetector.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenSetup createState() => _FeedScreenSetup();
}

class _FeedScreenSetup extends State<FeedScreen> {
  late AudioPlayer _player;
  late var _playlist;
  
  late var credentials;
  late var spotify;
  
  @override
  void initState() {
    super.initState();
    credentials = Spotify.SpotifyApiCredentials(clientId, clientSecret);
    spotify = Spotify.SpotifyApi(credentials);
    _player = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    SpotifyApi api = new SpotifyApi();
    var _credentials = await spotify.getCredentials();
    
    ArtistTopTracks _tracks = await api.getTopTracks('7qHsapL39aTQsPhixtzVvy', 'IN', _credentials.accessToken);
    var tracks = _tracks.tracks;
    
    List<AudioSource> playlist = [];
    tracks.forEach((track){
      playlist.add(AudioSource.uri(
        Uri.parse(
            track.previewUrl),
        tag: AudioMetadata(
          album: track.album.name,
          title: track.name,
          artwork:
              track.album.images[0].url,
        ),
      ));
    });
    //playlist = playlist.reversed.toList();
    _playlist = ConcatenatingAudioSource(children: playlist);
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      // catch load errors: 404, invalid url ...
      print("An error occured $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      body: SwipeDetector(
        onSwipeDown: () {
          if (_player.hasPrevious)
            _player.seekToPrevious();
        },
        onSwipeUp: () {
          if (_player.hasNext)
            _player.seekToNext();
        },
        child: Container(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 40,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                primaryColor,
                black
              ],
              end: Alignment.bottomCenter,
            ),
          ),
          child: _player.processingState == ProcessingState.idle ? SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: StreamBuilder<SequenceState?>(
                    stream: _player.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      if (state?.sequence.isEmpty ?? true) return SizedBox();
                      final metadata = state!.currentSource!.tag as AudioMetadata;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "NOW PLAYING",
                            style: Theme.of(context).textTheme.headline6
                          ),
                          Text(metadata.title,
                              style: Theme.of(context).textTheme.headline6),
                          Text(metadata.album),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                    metadata.artwork),
                              ),
                              width: 325,
                          ),
                          SizedBox(
                            height: 50,
                          ),          
                        ],
                      );
                    },
                  ),
                ),
                StreamBuilder<Duration?>(
                  stream: _player.durationStream,
                  builder: (context, snapshot) {
                    final duration = snapshot.data ?? Duration.zero;
                    return StreamBuilder<PositionData>(
                      stream: Rx.combineLatest2<Duration, Duration, PositionData>(
                          _player.positionStream,
                          _player.bufferedPositionStream,
                          (position, bufferedPosition) =>
                              PositionData(position, bufferedPosition)),
                      builder: (context, snapshot) {
                        final positionData = snapshot.data ??
                            PositionData(Duration.zero, Duration.zero);
                        var position = positionData.position;
                        if (position > duration) {
                          position = duration;
                        }
                        var bufferedPosition = positionData.bufferedPosition;
                        if (bufferedPosition > duration) {
                          bufferedPosition = duration;
                        }
                        return SeekBar(
                          duration: duration,
                          position: position,
                          bufferedPosition: bufferedPosition,
                          onChangeEnd: (newPosition) {
                            _player.seek(newPosition);
                          },
                        );
                      },
                    );
                  },
                ),
                ControlButtons(_player),
                SizedBox(height: 8.0),
                _player.hasNext == false ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.keyboard_arrow_up, 
                      color: white
                    ),
                    Text('Swipe Up',
                      style: Theme.of(context).textTheme.headline6,)
                  ],
                ) : Container(),
              ],
            ),
          ) : SpinKitWave(
            color: Colors.white,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;

  PositionData(this.position, this.bufferedPosition);
}