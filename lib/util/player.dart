import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/server/common.dart';

// 播放控制类
class playerController {
  AudioPlayer audioPlayer;
  int index = store.state.playState['playingData']['index'];
  final playlist = store.state.playState['playingData']['playList'];

  playerController() {
    _init();
  }

  _init() {
    // 为了在播放页面退出后还能保持播放，将播放器对象放入redux，避免其反复声明
    audioPlayer = store.state.playState['playingData']['controller'];
    if (audioPlayer == null) {
      // 如果播放器为null，说明播放器还未实例化，将其实例化并放入Redux
      store.state.playState['playingData']['controller'] = new AudioPlayer();
      audioPlayer = store.state.playState['playingData']['controller'];
    }
  }

  _playByIndex() async {
    String id = playlist[index]['id'].toString();
    await getSongDetail(id);
    await getSongUrl(id);
    await getLyric(id);
    store.dispatch({
      'type': 'changePlay',
      'payload': 'play',
    });
    store.dispatch({
      'type': 'setPlayingData',
      'payload': {
        'index': index,
      },
    });
    play(store.state.playState['playingData']['mp3Url']);
  }

  void onDurationChanged(Function callback) {
    audioPlayer.onDurationChanged.listen(callback);
  }

  void onAudioPositionChanged(Function callback) {
    audioPlayer.onAudioPositionChanged.listen(callback);
  }

  void onPlayerStateChanged(Function callback) {
    audioPlayer.onPlayerStateChanged.listen(callback);
  }

  void play(String url) async {
    await audioPlayer.play(url);
  }

  void pause() async {
    await audioPlayer.pause();
  }

  void resume() async {
    await audioPlayer.resume();
  }

  void stop() async {
    await audioPlayer.stop();
  }

  void destroy() async {
    audioPlayer = null;
  }

  void next() async {
    if (index < playlist.length - 1) {
      index++;
    } else {
      index = 0;
    }
    try {
      _playByIndex();
    } catch (e) {
      next();
    }
  }

  void prev() async {
    if (index > 0) {
      index--;
    } else {
      index = playlist.length - 1;
    }
    try {
      _playByIndex();
    } catch (e) {
      prev();
    }
  }
}
