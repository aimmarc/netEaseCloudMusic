import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/server/common.dart';
import 'package:flutter_app/util/player.dart';
import 'package:weui/weui.dart';

class DrawerPlaylistBtn extends StatelessWidget {
  List<Widget> children = [];

  playerController audioPlayer = playerController();
  final theme;
  Function close;

  DrawerPlaylistBtn(this.theme);

  void show(context) {
    close = weDrawer(context)(
      placement: WeDrawerPlacement.bottom,
      child: Align(
        alignment: Alignment.center,
        child: _build(context),
      ),
    );
  }

  Widget _build(context) {
    final playlist = store.state.playState['playingData']['playList'];
    children = [];
    for (int i = 0; i < playlist.length; i++) {
      final item = playlist[i];
      final songId = item['id'].toString();
      final playing = store.state.playState['playingData']['id'] == songId;
      children.add(ListTile(
        onTap: () async {
          if (item['fee'] == 0) {
            return;
          }
          await getSongDetail(songId);
          await getSongUrl(songId);
          await getLyric(songId);
          store.dispatch({
            'type': 'changePlay',
            'payload': 'play',
          });
          store.dispatch({
            'type': 'setPlayingData',
            'payload': {
              'id': songId,
              'percent': 0.0,
              'index': i,
            }
          });
          store.state.playState['isNewPlay'] = true;
          audioPlayer.play(store.state.playState['playingData']['mp3Url']);
        },
        title: Row(
          children: <Widget>[
            playing
                ? Icon(
                    Icons.play_circle_filled,
                    color: Colors.red,
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(
                left: 6,
              ),
            ),
            Expanded(
              child: Text(
                item['name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color:
                      item['fee'] == 0 ? Color(0xff999999) : Color(0xff333333),
                ),
              ),
            ),
          ],
        ),
        trailing: InkWell(
          onTap: () async {
            print(item['fee']);
          },
          child: Icon(Icons.clear),
        ),
      ));
    }
    return Container(
      height: 400,
      child: Scaffold(
        body: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 16.0),
                decoration: new BoxDecoration(
                  border: new Border(
                    bottom: BorderSide(color: Color(0xFFdddddd), width: 0.5),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.loop, // shuffle
                            color: Color(0xff999999),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Text('列表循环(${playlist.length})'),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        close();
                        audioPlayer.stop();
                        store.dispatch({
                          'type': 'setPlayingData',
                          'payload': {
                            'playList': [],
                          },
                        });
                        store.dispatch({
                          'type': 'changePlay',
                          'payload': 'stop',
                        });
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: Color(0xff999999),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: false,
                  children: children,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IconButton(
      onPressed: () {
        show(context);
      },
      icon: Icon(Icons.playlist_play,
          color: theme == 'dark' ? Colors.black : Colors.white),
    );
  }
}
