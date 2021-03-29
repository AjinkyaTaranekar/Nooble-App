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
  bool loaded = false;

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
    
    ArtistTopTracks _tracks = await api.getTopTracks('4YRxDV8wJFPHPTeXepOstw', 'IN', _credentials.accessToken);
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
      setState(() {
        loaded = true;
      });
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
            top: height*0.1,
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
          child: loaded ? SafeArea(
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
                            height: height*0.05,
                          ),
                          Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(width*0.15),
                                child: Image.network(
                                    metadata.artwork,
                                    frameBuilder: (BuildContext context, Widget child, int? frame,
                                        bool wasSynchronouslyLoaded) {
                                      if (wasSynchronouslyLoaded) {
                                        return child;
                                      }
                                      return AnimatedOpacity(
                                        child: child,
                                        opacity: frame == null ? 0 : 1,
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.easeOut,
                                      );
                                    },),
                              ),
                              width: width*0.8,
                              height: height*0.35,
                          ),
                          SizedBox(
                            height: height*0.05,
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.keyboard_arrow_up, 
                      color: white
                    ),
                    Text('Swipe Up',
                      style: Theme.of(context).textTheme.headline6,)
                  ],
                ),
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