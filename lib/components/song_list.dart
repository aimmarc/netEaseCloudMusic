import 'package:flutter/material.dart';
import 'package:flutter_app/components/box.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weui/weui.dart';
import 'package:dio/dio.dart';
import '../common/global.dart';
import 'image_block.dart';

class SongList extends StatefulWidget {
  @override
  SongListState createState() => SongListState();
}

class SongListState extends State {
  var songList = [];

  // 获取歌单
  getSongList(BuildContext context) async {
    print('发起请求');
    try {
      Response response =
          await Dio().get("$API_PREFIX/personalized?limit=6").catchError((e) {
        print(e);
      });
      final data = response.data;
      if (data['code'] == 200) {
        setState(() {
          songList = data['result'];
        });
      } else {
        WeToast.fail(context)(message: response.data['message']);
      }
    } catch (e) {
      WeToast.fail(context)(message: '未知错误');
      print(e);
    }
  }

  Widget itemBuilder(int index) {
    final item = songList[index];
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('playlistId', item['id'].toString());
        Navigator.of(context).pushNamed('/playlist');
      },
      child: new Padding(
        padding: EdgeInsets.only(top: 0, bottom: 16, left: 8, right: 8),
        child: ImageBlock(item),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getSongList(context);
  }

  @override
  Widget build(BuildContext context) {
    return songList.length > 0
        ? new Container(
            child: new Column(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.all(16.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: Text(
                          '推荐歌单',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        flex: 1,
                      ),
                      WeButton(
                        '歌单广场',
                        size: WeButtonSize.mini,
                        onClick: () {
                          Navigator.of(context).pushNamed('/square');
                        },
                      ),
                    ],
                  ),
                ),
                new Padding(
                  padding:
                      EdgeInsets.only(top: 0, bottom: 0, left: 8, right: 8),
                  child: WeGrid(
                      count: 3,
                      itemCount: 6,
                      border: BorderSide.none,
                      itemBuilder: itemBuilder),
                )
              ],
            ),
          )
        : new Container(
            height: 300,
            child: new WeSpin(
              isShow: true,
              tip: Text('加载中...'),
            ),
          );
  }
}
