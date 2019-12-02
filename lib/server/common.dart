import 'package:flutter_app/common/global.dart';
import 'package:flutter_app/util/request.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

// 获取歌曲详情
getSongDetail(String id) async {
  try {
    final response =
        await DioUtil.getInstance().post("$API_PREFIX/song/detail?ids=$id", {});
    final data = response.data;
    var playData = store.state.playState['playingData'];
    playData['imgUrl'] = data['songs'][0]['al']['picUrl'];
    playData['name'] = data['songs'][0]['name'];
    playData['id'] = data['songs'][0]['id'];
    playData['ar'] = data['songs'][0]['ar'];
    store.dispatch({
      'type': 'setPlayingData',
      'payload': playData,
    });
  } catch (e) {
    print(e);
  }
}

// 获取音乐url
getSongUrl(String id) async {
  try {
    final response = await DioUtil.getInstance()
        .post("$API_PREFIX/song/url?id=$id&br=320000", {});
    final data = response.data;
    String url = data['data'][0]['url'];
    url = 'https${url.split('http')[1]}';
    var playDate = store.state.playState['playingData'];
    playDate['mp3Url'] = url;
    store.dispatch({
      'type': 'setPlayingData',
      'payload': playDate,
    });
  } catch (e) {
    print(e);
  }
}

// 获取歌词
getLyric(String id) async {
  try {
    final response =
        await DioUtil.getInstance().post("$API_PREFIX/lyric?id=$id", {});
    final data = response.data;
    String lrc = data['lrc']['lyric'];
    var playDate = store.state.playState['playingData'];
    playDate['lrc'] = lrc;
    store.dispatch({
      'type': 'setPlayingData',
      'payload': playDate,
    });
  } catch (e) {
    print(e);
  }
}

getSongList() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.get('userId');
    final response = await DioUtil.getInstance()
        .post("$API_PREFIX/user/playlist?uid=$userId", {});
    final data = response.data;
    var homeDate = store.state.playState['home'];
    homeDate['songlist'] = data['playlist'];
    store.dispatch({
      'type': 'setHome',
      'payload': homeDate,
    });
  } catch (e) {
    print(e);
  }
}
