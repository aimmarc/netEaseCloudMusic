import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/slidup_playlist.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/redux/index.dart';
import 'package:flutter_app/util/player.dart';
import 'package:flutter_redux/flutter_redux.dart';

class PlayBar extends StatefulWidget {
  @override
  PlayBarState createState() => PlayBarState();
}

class PlayBarState extends State with TickerProviderStateMixin {
  AnimationController controller;
  Duration total = Duration(seconds: 0);
  double _percent = 0.0;

  playerController audioPlayer = playerController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 14), vsync: this);

    audioPlayer.onDurationChanged((Duration d) {
      total = d;
    });

    audioPlayer.onAudioPositionChanged((Duration p) {
      if (total == null || audioPlayer == null) {
        return;
      }
      final passed = p.inMilliseconds - p.inMilliseconds;
      if (passed > 1000 || passed <= 0) {
        setState(() {
          _percent = p.inMilliseconds / total.inMilliseconds;
        });
      }

      if ((total.inMilliseconds - p.inMilliseconds) <= 1000) {
        store.dispatch({
          'type': 'changePlay',
          'payload': 'stop',
        });
        audioPlayer.next();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = store.state.playState;
    if (state['play'] == 'play') {
      controller.repeat();
    } else {
      controller.stop();
    }
    return StoreConnector<PlayState, Map>(
      converter: (store) => state,
      builder: (context, play) {
        int len = play['playingData']['playList'].length;
        if (play['play'] == 'play') {
          controller.repeat();
        }
        return len > 0
            ? InkWell(
                onTap: () {
                  state['isNewPlay'] = false;
                  Navigator.of(context).pushNamed('/player');
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(
                              color: Color(0xFFe0e0e0), width: 0.5))),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 1,
                        child: LinearProgressIndicator(
                          value: _percent,
                          backgroundColor: Colors.white,
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 6.0, right: 6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: Container(
                                      padding: EdgeInsets.all(0),
                                      child: play['playingData']['imgUrl'] ==
                                                  null ||
                                              play['playingData']['imgUrl'] ==
                                                  ''
                                          ? Icon(
                                              Icons.album,
                                              size: 45,
                                            )
                                          : RotationTransition(
                                              turns: controller,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          168.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        play['playingData']
                                                            ['imgUrl'],
                                                    width: 45,
                                                    height: 45,
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                    ),
                                  )),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            play['playingData']['name'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )),
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '横滑可以切换上下首哦',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: Color(0xff999999)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              StoreConnector<PlayState, VoidCallback>(
                                  converter: (store) {
                                return () {
                                  if (play['play'] != 'play') {
                                    store.dispatch({
                                      'type': 'changePlay',
                                      'payload': 'play'
                                    });
                                    audioPlayer.resume();
                                    controller.forward();
                                  } else {
                                    store.dispatch({
                                      'type': 'changePlay',
                                      'payload': 'puase'
                                    });
                                    audioPlayer.pause();
                                    controller.stop();
                                  }
                                };
                              }, builder: (context, callback) {
                                return IconButton(
                                  icon: Icon(
                                    play['play'] != 'play'
                                        ? Icons.play_arrow
                                        : Icons.pause,
                                    size: 32,
                                  ),
                                  onPressed: callback,
                                );
                              }),
                              DrawerPlaylistBtn('dark'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container();
      },
    );
  }

  @override
  void dispose() {
    if (controller != null) {
      controller.stop();
      controller.dispose();
    }
    if (audioPlayer != null) {
      audioPlayer.destroy();
      audioPlayer = null;
    }
    super.dispose();
  }
}
