import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/global.dart';
import 'package:flutter_app/components/SliverAppBarDelegate.dart';
import 'package:flutter_app/components/action_song.dart';
import 'package:flutter_app/components/load_more.dart';
import 'package:flutter_app/components/play_all.dart';
import 'package:flutter_app/server/common.dart';
import 'package:flutter_app/util/request.dart';

import '../main.dart';

class NewSongItemPage extends StatefulWidget {
  int type;
  NewSongItemPage(this.type);
  @override
  NewSongItemState createState() => NewSongItemState(type);
}

class NewSongItemState extends State with AutomaticKeepAliveClientMixin {
  int type;
  Map _titles = {0: '推荐', 7: '华语', 96: '欧美', 8: '日本', 16: '韩国'};
  List _newSongs = [];
  bool _isLoading = false;

  NewSongItemState(this.type);

  @override
  void initState() {
    super.initState();
    _getNewSong();
  }

  void _getNewSong() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await DioUtil.getInstance()
          .post("$API_PREFIX/top/song?type=$type", {});
      setState(() {
        _isLoading = false;
      });
      final data = response.data;
      if (data['code'] == 200) {
        setState(() {
          _newSongs.addAll(data['data']);
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  Widget _buildList(int index) {
    final item = _newSongs[index];
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
            'playList': _newSongs,
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
                  placeholder: (context, url) => CircularProgressIndicator(),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _newSongs[index]['name'],
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(
                      _newSongs[index]['artists'][0]['name'],
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: 150,
              child: Image(
                image: AssetImage('lib/assets/images/tj.png'),
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true, //是否固定在顶部
            floating: true,
            delegate: SliverAppBarDelegate(
              minHeight: 50, //收起的高度
              maxHeight: 50, //展开的最大高度
              child: Container(
                color: Colors.white,
                child: PlayAll('20'),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildList(index);
              },
              childCount: _newSongs.length > 20 ? 20 : 0,
            ),
          ),
          SliverToBoxAdapter(
            child: LoadMore(_isLoading, _isLoading ? '加载中...' : '- 没有更多了 -'),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
