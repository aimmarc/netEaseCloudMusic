import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/global.dart';
import 'package:flutter_app/components/action_song.dart';
import 'package:flutter_app/components/box.dart';
import 'package:flutter_app/components/custom_appbar.dart';
import 'package:flutter_app/components/load_more.dart';
import 'package:flutter_app/components/play_bar.dart';
import 'package:flutter_app/server/common.dart';
import 'package:flutter_app/util/request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weui/toast/index.dart';
import 'package:weui/weui.dart';

import '../main.dart';

class PlayListPage extends StatefulWidget {
  @override
  PlayListState createState() => PlayListState();
}

class PlayListState extends State with AutomaticKeepAliveClientMixin {
  List playlists = [];
  String title = '歌单';
  var listInfo = {};
  bool _isLoading = false;

  getPlaylist(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = prefs.get('playlistId');
      final response = await DioUtil.getInstance()
          .post("$API_PREFIX/playlist/detail?id=$id", {});
      setState(() {
        _isLoading = false;
      });
      final data = response.data;
      if (data['code'] == 200) {
        setState(() {
          listInfo = data['playlist'];
          playlists = listInfo['tracks'];
          title = data['playlist']['name'];
        });
      } else {
        WeToast.info(context)(data['message']);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      WeToast.info(context)('未知错误');
    }
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getPlaylist(context);
  }

  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              listInfo['coverImgUrl'] != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(3.0),
                      child: CachedNetworkImage(
                        height: 120.0,
                        width: 120.0,
                        fit: BoxFit.cover,
                        imageUrl: listInfo['coverImgUrl'],
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                      ),
                    )
                  : Container(
                      width: 120.0,
                      height: 120.0,
                      color: Colors.grey,
                    ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                      box,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: listInfo['coverImgUrl'] != null
                                ? Image(
                                    height: 30.0,
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        listInfo['creator']['avatarUrl']),
                                  )
                                : Text(
                                    '加载中...',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Text(
                            listInfo['coverImgUrl'] != null
                                ? listInfo['creator']['nickname']
                                : '加载中...',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.0),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 12.0, color: Colors.white),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(13.0),
                      ),
                      Row(
                        children: <Widget>[
                          Text('编辑信息',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.0)),
                          Icon(Icons.arrow_forward_ios,
                              size: 12.0, color: Colors.white),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          box,
          box,
          Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                children: <Widget>[
                  Icon(
                    Icons.comment,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                  ),
                  Text(
                    '评论',
                    style: TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ],
              )),
              Expanded(
                  child: Column(
                children: <Widget>[
                  Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                  ),
                  Text(
                    '分享',
                    style: TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ],
              )),
              Expanded(
                  child: Column(
                children: <Widget>[
                  Icon(
                    Icons.file_download,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                  ),
                  Text(
                    '下载',
                    style: TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ],
              )),
              Expanded(
                  child: Column(
                children: <Widget>[
                  Icon(
                    Icons.done_all,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                  ),
                  Text(
                    '多选',
                    style: TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  elevation: 0,
                  pinned: true,
                  brightness: Brightness.dark,
                  backgroundColor: Theme.of(context).accentColor,
                  expandedHeight: 325.0,
                  iconTheme: IconThemeData(color: Colors.white),
                  title: Text(
                    title,
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: <Widget>[
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.more_vert,
                        ))
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Container(
                      width: double.infinity,
                      height: 220,
                      padding: EdgeInsets.only(top: 80.0),
                      child: Stack(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              child: listInfo['coverImgUrl'] == null
                                  ? null
                                  : CachedNetworkImage(
                                      imageUrl: listInfo['coverImgUrl'],
                                      width: 750,
                                      height: 300,
                                      fit: BoxFit.cover,
                                    )),
                          Container(
                            height: 220,
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                              child: Container(
                                color: Color(0xff757575).withAlpha(1),
                              ),
                            ),
                          ),
                          _buildTitle(),
                        ],
                      ),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48.0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(playlists.length > 0
                              ? listInfo['coverImgUrl']
                              : ''),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          color: Colors.white,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Icon(Icons.play_circle_outline),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 12.0),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text('播放全部'),
                                  Text(
                                    '（共${playlists.length}首）',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Color(0xff999999),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = playlists[index];
                    return ListTile(
                      onTap: () async {
                        if (playlists[index]['fee'] == 0) {
                          return;
                        }
                        final songId = playlists[index]['id'].toString();
                        store.dispatch({
                          'type': 'setPlayingData',
                          'payload': {
                            'id': songId,
                            'playList': playlists,
                            'percent': 0.0,
                            'index': index,
                          }
                        });
                        String id = songId.toString();
                        await getSongDetail(id);
                        await getSongUrl(id);
                        await getLyric(id);
                        store.dispatch({
                          'type': 'changePlay',
                          'payload': 'play',
                        });
                        store.state.playState['isNewPlay'] = true;
                        Navigator.of(context).pushNamed(
                          '/player',
                        );
                      },
                      title: Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              width: 35,
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(
                                  color: Color(0xffc909090),
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    playlists[index]['name'],
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: playlists[index]['fee'] != 0
                                          ? Colors.black
                                          : Color(0xff999999),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      playlists[index]['ar'][0]['name'],
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: playlists[index]['fee'] != 0
                                              ? Color(0xff666666)
                                              : Color(0xff999999)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Icon(
                                Icons.ondemand_video,
                                color: Color(0xff999999),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                            ),
                            InkWell(
                              onTap: () {},
                              child: SongActionBtn(Color(0xff999999), {
                                'imgUrl': item['al']['picUrl'],
                                'name': item['name'],
                                'ar': item['ar'],
                                'id': item['id'],
                              }),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: playlists.length,
                )),
                SliverToBoxAdapter(
                  child:
                      LoadMore(_isLoading, _isLoading ? '加载中...' : '- 没有更多了 -'),
                ),
              ],
            ),
          ),
          PlayBar(),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
