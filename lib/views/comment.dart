import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/global.dart';
import 'package:flutter_app/components/box.dart';
import 'package:flutter_app/components/load_more.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/util/request.dart';

class CommentPage extends StatefulWidget {
  @override
  CommentState createState() => CommentState();
}

class CommentState extends State {
  ScrollController _controller = ScrollController();
  List _hotComments = [];
  List _comments = [];
  int _total = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  var _before = '';
  final _playData = store.state.playState['commentData'];

  @override
  void initState() {
    super.initState();
    _getComments();
  }

  void _getComments() async {
    _isLoading = true;
    final songId = _playData['id'];
    try {
      final response = await DioUtil.getInstance().post(
        "$API_PREFIX/comment/music?id=$songId&limit=20&before=$_before",
        {},
      );
      _isLoading = false;
      final data = response.data;
      if (data['code'] == 200) {
        if (data['comments'] == null || data['comments'].length == 0) {
          setState(() {
            _hasMore = false;
          });
          return;
        }
        setState(() {
          if (data['hotComments'] != null) {
            _hotComments = data['hotComments'];
          }
          _comments.addAll(data['comments']);
          _total = data['total'];
        });
      }
    } catch (e) {
      _isLoading = false;
    }
  }

  Widget _buildItem(int index, List comments) {
    final item = comments[index];
    final user = item['user'];
    final time = DateTime.fromMillisecondsSinceEpoch(item['time']);

    return ListTile(
      onTap: () {},
      title: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: CachedNetworkImage(
                    imageUrl: user['avatarUrl'],
                    width: 30.0,
                    height: 30.0,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(),
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user['nickname'],
                        style: TextStyle(
                          color: Color(0xff999999),
                          fontSize: 12.0,
                        ),
                      ),
                      Text(time.toString().split(' ')[0],
                          style: TextStyle(
                            color: Color(0xff999999),
                            fontSize: 10.0,
                          )),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      item['likedCount'].toString(),
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Color(0xff999999),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6.0),
                    ),
                    Icon(
                      Icons.thumb_up,
                      size: 14.0,
                      color: Color(0xff999999),
                    ),
                  ],
                )
              ],
            ),
            box,
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 40.0),
                ),
                Expanded(
                  child: Text(
                    item['content'],
                    style: TextStyle(fontSize: 14.0, color: Color(0xff444444)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBox() {
    return Container(
      height: 10.0,
      color: Color(0xfff9f9f9),
    );
  }

  Widget _buildTitle(String title) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Text(
          title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('评论'),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: Container(
        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (_isLoading || _comments.length == 0 || !_hasMore) {
              return;
            }
            if (_comments.length == _total) {
              setState(() {
                _hasMore = false;
              });
              return;
            }

            ScrollMetrics metrics = notification.metrics;
            if (metrics.extentAfter < 10) {
              _before = _comments[_comments.length - 1]['time'].toString();
              _getComments();
            }
          },
          child: CustomScrollView(
            controller: _controller,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: CachedNetworkImage(
                          imageUrl: _playData['imgUrl'],
                          width: 80.0,
                          height: 80.0,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _playData['name'],
                              style: TextStyle(fontSize: 16.0),
                            ),
                            box,
                            Text(
                              _playData['ar'][0]['name'],
                              style: TextStyle(color: Colors.blueGrey),
                            )
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14.0,
                        color: Color(0xff999999),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildBox(),
              ),
              _buildTitle('精彩评论'),
              SliverList(
                delegate: SliverChildListDelegate(
                  //返回组件集合
                  List.generate(_hotComments.length, (int index) {
                    return _buildItem(index, _hotComments);
                  }),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildBox(),
              ),
              _buildTitle('最新评论（$_total）'),
              SliverList(
                delegate: SliverChildListDelegate(
                  //返回组件集合
                  List.generate(_comments.length, (int index) {
                    return _buildItem(index, _comments);
                  }),
                ),
              ),
              SliverToBoxAdapter(
                child: LoadMore(_hasMore, _hasMore ? '评论加载中...' : '- 没有更多了 -'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
