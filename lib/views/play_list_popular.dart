import 'package:flutter/material.dart';
import 'package:flutter_app/common/global.dart';
import 'package:flutter_app/components/box.dart';
import 'package:flutter_app/components/image_block.dart';
import 'package:flutter_app/components/load_more.dart';
import 'package:flutter_app/util/request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayPopularPage extends StatefulWidget {
  String cat;
  PlayPopularPage(this.cat);
  @override
  PlayPopularState createState() => PlayPopularState(cat);
}

class PlayPopularState extends State with AutomaticKeepAliveClientMixin {
  String cat;
  ScrollController _controller = ScrollController();
  List _playLists = [];
  bool _hasMore = true;
  bool _isLoading = false;
  String _before = '';

  PlayPopularState(this.cat);

  Future _getPlayList() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await DioUtil.getInstance().post(
        "$API_PREFIX/top/playlist?limit=30&before=$_before&cat=$cat",
        {},
      );
      setState(() {
        _isLoading = false;
      });
      final data = response.data;
      if (data['code'] == 200) {
        if (data['playlists'] == null || data['playlists'].length == 0) {
          _hasMore = false;
        }
        setState(() {
          _playLists.addAll(data['playlists']);
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPlayList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (_isLoading || _playLists.length == 0 || !_hasMore) {
              return;
            }

            ScrollMetrics metrics = notification.metrics;
            if (metrics.extentAfter < 10) {
              _before =
                  _playLists[_playLists.length - 1]['updateTime'].toString();
              _getPlayList();
            }
          },
          child: CustomScrollView(
            controller: _controller,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: box,
              ),
              SliverToBoxAdapter(
                child: box,
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: .7,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final item = _playLists[index];
                    return Container(
                      child: InkWell(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString('playlistId', item['id'].toString());
                          Navigator.of(context).pushNamed('/playlist');
                        },
                        child: ImageBlock({
                          'name': item['name'],
                          'picUrl': item['coverImgUrl'],
                        }),
                      ),
                    );
                  },
                  childCount: _playLists.length,
                ),
              ),
              SliverToBoxAdapter(
                child: LoadMore(_hasMore, _hasMore ? '歌单加载中...' : '- 没有更多了 -'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
