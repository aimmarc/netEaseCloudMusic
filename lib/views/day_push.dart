import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/global.dart';
import 'package:flutter_app/components/action_song.dart';
import 'package:flutter_app/components/load_more.dart';
import 'package:flutter_app/components/play_bar.dart';
import 'package:flutter_app/server/common.dart';
import 'package:flutter_app/util/request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weui/toast/index.dart';
import 'package:weui/weui.dart';

import '../main.dart';

class DayPushPage extends StatefulWidget {
  @override
  DayPushState createState() => DayPushState();
}

class DayPushState extends State with AutomaticKeepAliveClientMixin {
  List playlists = [];
  var listInfo = {};
  bool _isLoading = false;

  getPlaylist(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response =
          await DioUtil.getInstance().post("$API_PREFIX/recommend/songs", {});
      setState(() {
        _isLoading = false;
      });
      final data = response.data;
      if (data['code'] == 200) {
        setState(() {
          playlists = data['data']['dailySongs'];
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
    super.initState();
    getPlaylist(context);
  }

  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Widget _buildTitle() {
    return Container(
      child: playlists.length > 0
          ? CachedNetworkImage(
              height: 40.0,
              width: 40.0,
              fit: BoxFit.cover,
              imageUrl: playlists[0]['album']['picUrl'],
              placeholder: (context, url) => CircularProgressIndicator(),
            )
          : Container(),
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
                  expandedHeight: 200.0,
                  iconTheme: IconThemeData(color: Colors.white),
                  title: Text(
                    "每日推荐",
                    style: TextStyle(color: Colors.white),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      "每日推荐",
                      style: TextStyle(color: Colors.white),
                    ),
                    collapseMode: CollapseMode.pin,
                    background: playlists.length > 0
                        ? Stack(
                            children: <Widget>[
                              CachedNetworkImage(
                                // height: 40.0,
                                width: 750.0,
                                fit: BoxFit.cover,
                                imageUrl: playlists[0]['album']['picUrl'],
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 100.0,
                                  left: 16.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      DateTime.now().day.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 34,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 3.0),
                                    ),
                                    Text(
                                      '/',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 3.0),
                                    ),
                                    Text(
                                      DateTime.now().month.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        : Container(),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48.0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(playlists.length > 0
                              ? playlists[0]['album']['picUrl']
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
                          if (item['fee'] == 0) {
                            return;
                          }
                          final songId = item['id'].toString();
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
                                padding: EdgeInsets.only(right: 10.0),
                                alignment: Alignment.centerLeft,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3.0),
                                  child: CachedNetworkImage(
                                    height: 40.0,
                                    width: 40.0,
                                    fit: BoxFit.cover,
                                    imageUrl: item['album']['picUrl'],
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
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
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        playlists[index]['artists'][0]['name'],
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Color(0xff666666),
                                        ),
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
                                  'imgUrl': item['album']['picUrl'],
                                  'name': item['name'],
                                  'ar': item['artists'],
                                  'id': item['id'],
                                }),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: playlists.length,
                  ),
                ),
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
