import 'package:meta/meta.dart';

@immutable
class PlayState {
  Map _playState;

  get playState => _playState;
  PlayState.initState() {
    _playState = {
      'play': 'stop',
      'isNewPlay': false,
      'playingData': {
        'id': '',
        'commentId': '',
        'playList': [],
        'index': null,
        'percent': null,
        'imgUrl': '',
        'mp3Url': '',
        'name': '',
        'musicPlayer': null,
        'controller': null,
        'lrc': '',
        'ar': null,
      },
      'commentData': {
        'id': '',
        'imgUrl': '',
        'name': '',
        'ar': [],
      },
      'home': {
        'songlist': [],
      },
    };
  }
  PlayState(this._playState);
}

PlayState reducer(PlayState state, action) {
  //匹配Action
  if (action['type'] == 'changePlay') {
    state.playState['play'] = action['payload'];
    return PlayState(state.playState);
  }
  if (action['type'] == 'setPlayingData') {
    state.playState['playingData'].addEntries(action['payload'].entries);
    return PlayState(state.playState);
  }
  if (action['type'] == 'setCommentData') {
    state.playState['commentData'].addEntries(action['payload'].entries);
    return PlayState(state.playState);
  }
  if (action['type'] == 'setHome') {
    state.playState['home'].addEntries(action['payload'].entries);
    return PlayState(state.playState);
  }
  return state;
}
