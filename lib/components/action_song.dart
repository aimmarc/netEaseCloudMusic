import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/util/player.dart';
import 'package:weui/weui.dart';

import '../main.dart';

class SongActionBtn extends StatelessWidget {
  Color color;
  Map songInfo;
  List<Widget> children = [];
  List actions = [
    {'title': '下一首播放', 'icon': Icon(Icons.play_arrow), 'callback': () {}},
    {'title': '收藏到歌单', 'icon': Icon(Icons.add_box), 'callback': () {}},
    {'title': '下载', 'icon': Icon(Icons.file_download), 'callback': () {}},
    {'title': '评论', 'icon': Icon(Icons.comment), 'callback': () {}},
    {'title': '分享', 'icon': Icon(Icons.share), 'callback': () {}},
    {'title': '歌手', 'icon': Icon(Icons.person), 'callback': () {}},
    {'title': '专辑', 'icon': Icon(Icons.album), 'callback': () {}},
    {'title': '设为铃声', 'icon': Icon(Icons.alarm), 'callback': () {}},
    {'title': '查看视频', 'icon': Icon(Icons.ondemand_video), 'callback': () {}},
    {'title': '删除', 'icon': Icon(Icons.delete_outline), 'callback': () {}},
    {'title': '屏蔽歌手或歌曲', 'icon': Icon(Icons.cancel), 'callback': () {}},
  ];
  playerController audioPlayer = playerController();
  Function close;

  SongActionBtn(this.color, this.songInfo);

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
    children = [];
    actions[5]['title'] = '歌手（${songInfo['ar'][0]['name']}）';
    for (int i = 0; i < actions.length; i++) {
      final item = actions[i];
      children.add(
        ListTile(
          onTap: () {
            switch (i) {
              case 3:
                final commentData = store.state.playState['commentData'];
                commentData['id'] = songInfo['id'];
                commentData['name'] = songInfo['name'];
                commentData['ar'] = songInfo['ar'];
                commentData['imgUrl'] = songInfo['imgUrl'];
                store.dispatch({
                  'type': 'setCommentData',
                  'payload': commentData,
                });
                Navigator.of(context).pushNamed('/comment');
                close();
            }
          },
          title: Row(
            children: <Widget>[
              item['icon'],
              Padding(
                padding: EdgeInsets.only(
                  left: 6,
                ),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    item['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
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
                // height: 50,
                padding: EdgeInsets.all(16.0),
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3.0),
                            child: CachedNetworkImage(
                              height: 40.0,
                              width: 40.0,
                              fit: BoxFit.cover,
                              imageUrl: songInfo['imgUrl'],
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(songInfo['name']),
                              Text(
                                songInfo['ar'][0]['name'],
                                style: TextStyle(
                                  fontSize: 11.0,
                                  color: Color(0xff999999),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: false,
                  children:
                      ListTile.divideTiles(context: context, tiles: children)
                          .toList(),
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
    return InkWell(
      onTap: () {
        show(context);
      },
      child: Icon(Icons.more_vert, color: color),
    );
  }
}
