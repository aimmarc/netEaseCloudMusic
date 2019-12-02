import 'package:flutter/material.dart';
import 'package:flutter_app/common/global.dart';
import 'package:flutter_app/components/image_block.dart';
import 'package:flutter_app/util/request.dart';
import 'package:weui/weui.dart';
import '../components/box.dart';
import '../components/home_swiper.dart';
import '../components/song_list.dart';
import '../components/new_disk.dart';

class FindPage extends StatefulWidget {
  @override
  FindPageState createState() => FindPageState();
}

class FindPageState extends State with AutomaticKeepAliveClientMixin {
  List _newSongs = [];

  Future getNewSong() async {
    try {
      final response =
          await DioUtil.getInstance().post("$API_PREFIX/top/song", {});
      final data = response.data;
      if (data['code'] == 200) {
        setState(() {
          _newSongs.add(data['data'][0]);
          _newSongs.add(data['data'][1]);
          _newSongs.add(data['data'][2]);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _itemBuilder(int index) {
    final item = _newSongs[index];
    return SizedBox(
      height: 160.0,
      child: new Padding(
        padding: EdgeInsets.only(top: 0, bottom: 16, left: 8, right: 8),
        child: ImageBlock({
          'picUrl': item['album']['picUrl'],
          'name': item['name'],
        }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getNewSong();
  }

  Widget _buildNewSong() {
    return Container(
      child: _newSongs.length > 0
          ? Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '新歌',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        flex: 1,
                      ),
                      WeButton(
                        '新歌速递',
                        size: WeButtonSize.mini,
                        onClick: () {
                          Navigator.of(context).pushNamed('/newSong');
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 0, bottom: 0, left: 8, right: 8),
                  child: WeGrid(
                      count: 3,
                      itemCount: 3,
                      border: BorderSide.none,
                      itemBuilder: _itemBuilder),
                )
              ],
            )
          : Container(
              height: 300,
              child: WeSpin(
                isShow: true,
                tip: Text('加载中...'),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final btns = [
      {'name': '每日推荐', 'icon': const Icon(Icons.calendar_today)},
      {'name': '歌单', 'icon': const Icon(Icons.receipt)},
      {'name': '排行榜', 'icon': const Icon(Icons.trending_up)},
      {'name': '电台', 'icon': const Icon(Icons.radio)},
      {'name': '直播', 'icon': const Icon(Icons.tv)},
    ];
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: HomeSwiper(),
              ),
              box,
              box,
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Color(0xFFEFEFEF), width: 0.5))),
                child: WeGrid(
                    count: 5,
                    itemCount: 5,
                    border: BorderSide.none,
                    itemBuilder: (int i) {
                      final item = btns[i];
                      return SizedBox(
                        height: 100,
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  color: Colors.red,
                                  child: IconButton(
                                    tooltip: '菜单',
                                    color: Colors.white,
                                    icon: item['icon'],
                                    onPressed: () {
                                      switch (item['name']) {
                                        case '每日推荐':
                                          Navigator.of(context)
                                              .pushNamed('/dayPush');
                                          break;
                                        case '歌单':
                                          Navigator.of(context)
                                              .pushNamed('/square');
                                          break;
                                        default:
                                          break;
                                      }
                                    },
                                  ),
                                ),
                              ),
                              box,
                              Text(
                                item['name'],
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              // 歌单
              SongList(),
              // 新歌
              _buildNewSong(),
              // 新碟
              NewDisk(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
