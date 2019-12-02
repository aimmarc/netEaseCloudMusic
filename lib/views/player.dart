import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/components/action_song.dart';
import 'package:flutter_app/components/box.dart';
import 'package:flutter_app/components/slider.dart';
import 'package:flutter_app/components/slidup_playlist.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/redux/index.dart';
import 'package:flutter_app/util/player.dart';
import 'package:flutter_redux/flutter_redux.dart';

class PlayerPage extends StatefulWidget {
  @override
  PlayerPageState createState() => PlayerPageState();
}

class PlayerPageState extends State with TickerProviderStateMixin {
  AnimationController controller;
  String id;
  String playUrl;
  bool showLrc = false;
  bool isNew = false;
  double _percent = 0.0;
  Duration total = Duration(seconds: 0);
  Duration duration = Duration(seconds: 0);
  Duration leftTime = Duration(seconds: 0);
  playerController audioPlayer = playerController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 14), vsync: this);
    _initPlayer();
    if (store.state.playState['play'] == 'play') {
      controller.repeat();
    } else {
      controller.stop();
    }
    id = store.state.playState['playingData']['id'].toString();
  }

  _initPlayer() {
    audioPlayer.onDurationChanged((Duration d) {
      total = d;
    });

    audioPlayer.onAudioPositionChanged((Duration p) {
      if (total == null || audioPlayer == null) {
        return;
      }
      if (duration == null) {
        duration = p;
      }
      final passed = p.inMilliseconds - duration.inMilliseconds;
      if (passed > 1000 || passed <= 0) {
        // final data = store.state.playState['playingData'];
        // data['percent'] = p.inMilliseconds / total.inMilliseconds;
        // store.dispatch({
        //   'type': 'setPlayingData',
        //   'payload': data,
        // });
        setState(() {
          duration = p;
          leftTime = total - duration;
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

    final playStatus = store.state.playState['play'];
    isNew = store.state.playState['isNewPlay'];
    if (playStatus == 'play' && isNew) {
      playMusic();
    }
  }

  playMusic() async {
    stop();
    playUrl = store.state.playState['playingData']['mp3Url'];
    audioPlayer.play(playUrl);
    store.dispatch({
      'type': 'changePlay',
      'payload': 'play',
    });
  }

  pause() async {
    audioPlayer.pause();
  }

  resume() async {
    if (playUrl == null && isNew) {
      playMusic();
      return;
    }
    audioPlayer.resume();
  }

  stop() async {
    audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    final play = store.state.playState;

    return Scaffold(
      backgroundColor: Color(0xff6d6f6c),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                child: play['playingData']['imgUrl'] == null
                    ? null
                    : CachedNetworkImage(
                        imageUrl: play['playingData']['imgUrl'],
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      )),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                color: Colors.red.withAlpha(20),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQueryData.fromWindow(window).padding.top),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              play['playingData']['name'] == ''
                                  ? ''
                                  : play['playingData']['name'],
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                                play['playingData']['ar'] == null
                                    ? ''
                                    : play['playingData']['ar'][0]['name'],
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Color(0xffc0c0c0),
                                ))
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Stack(
                    children: <Widget>[
                      showLrc
                          ? Container()
                          : Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(top: 80),
                              height: 350,
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Image(
                                      image: AssetImage(
                                          'lib/assets/images/circle_bg.png'),
                                      width: 280,
                                      height: 280,
                                    ),
                                  ),
                                  Center(
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(168.0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            showLrc = true;
                                          });
                                        },
                                        onLongPress: () {},
                                        child: RotationTransition(
                                          turns: controller,
                                          child: play['playingData']
                                                      ['imgUrl'] ==
                                                  null
                                              ? null
                                              : CachedNetworkImage(
                                                  imageUrl: play['playingData']
                                                      ['imgUrl'],
                                                  width: 168,
                                                  height: 168,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                      showLrc
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.only(left: 85),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Image(
                                  image: AssetImage(
                                      'lib/assets/images/changzhen.png'),
                                  width: 120,
                                ),
                              ),
                            ),
                      showLrc
                          ? SingleChildScrollView(
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(20.0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      showLrc = false;
                                    });
                                  },
                                  child: Text(
                                    play['playingData']['lrc'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  )),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.file_download,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.surround_sound,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                final commentData = play['commentData'];
                                commentData['id'] =
                                    play['playingData']['id'].toString();
                                commentData['name'] =
                                    play['playingData']['name'];
                                commentData['ar'] = play['playingData']['ar'];
                                commentData['imgUrl'] =
                                    play['playingData']['imgUrl'];
                                store.dispatch({
                                  'type': 'setCommentData',
                                  'payload': commentData,
                                });
                                Navigator.of(context).pushNamed('/comment');
                              },
                              icon: Icon(
                                Icons.comment,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SongActionBtn(
                              Colors.white,
                              play['playingData'],
                            ),
                          ),
                        ],
                      ),
                      box,
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              width: 50,
                              child: Text(
                                duration.toString().split('.')[0],
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SliderStatePage(_percent),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 50,
                              child: Text(
                                leftTime.toString().split('.')[0],
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      box,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: IconButton(
                              icon: Icon(Icons.loop, // shuffle
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                try {
                                  audioPlayer.prev();
                                  controller.repeat();
                                } catch (e) {
                                  controller.stop();
                                }
                              },
                              icon: Icon(Icons.skip_previous,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          Expanded(
                            child: StoreConnector<PlayState, VoidCallback>(
                                converter: (store) {
                              return () {
                                if (play['play'] != 'play') {
                                  resume();
                                  store.dispatch({
                                    'type': 'changePlay',
                                    'payload': 'play'
                                  });
                                  controller.repeat();
                                } else {
                                  store.dispatch({
                                    'type': 'changePlay',
                                    'payload': 'puase'
                                  });
                                  controller.stop();
                                  pause();
                                }
                              };
                            }, builder: (context, callback) {
                              if (play['playingData']['playList'].length == 0) {
                                Navigator.of(context).pop();
                              }
                              return IconButton(
                                onPressed: callback,
                                iconSize: 50,
                                icon: Icon(
                                    play['play'] != 'play'
                                        ? Icons.play_arrow
                                        : Icons.pause,
                                    color: Theme.of(context).primaryColor),
                              );
                            }),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                try {
                                  audioPlayer.next();
                                  controller.repeat();
                                } catch (e) {
                                  controller.stop();
                                }
                              },
                              icon: Icon(Icons.skip_next,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          Expanded(
                            child: DrawerPlaylistBtn('lignt'),
                          ),
                        ],
                      ),
                      box,
                      box,
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
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
