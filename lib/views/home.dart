import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/global.dart';
import 'package:flutter_app/components/box.dart';
import 'package:flutter_app/redux/index.dart';
import 'package:flutter_app/server/common.dart';
import 'package:flutter_app/util/request.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weui/weui.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State with AutomaticKeepAliveClientMixin {
  var _listFont = const TextStyle(fontSize: 14.0);
  var rightColor = Color(0xff999999);
  var listRight = const TextStyle(fontSize: 12.0, color: Color(0xff999999));
  var userInfo = {};
  var _userId;
  var playList = [];
  List<Widget> playListWifget = [];
  List<Widget> collectWifget = [];

  getUserInfo(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.get('userId');
      final response = await DioUtil.getInstance()
          .post("$API_PREFIX/user/detail?uid=$userId", {});
      final data = response.data;
      if (data['code'] == 200) {
        setState(() {
          userInfo = data;
        });
      } else {}
    } catch (e) {
      WeToast.fail(context)(message: '未知错误');
      print(e);
    }
  }

  // 获取歌单
  getSongList22(BuildContext context) async {
    try {
      final response = await DioUtil.getInstance()
          .post("$API_PREFIX/user/playlist?uid=$_userId", {});
      final data = response.data;
      if (data['code'] == 200) {
        setState(() async {
          playList = data['playlist'];
          for (int index = 0; index < playList.length; index++) {
            Widget child = InkWell(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('playlistId', playList[index]['id'].toString());
                Navigator.of(context).pushNamed('/playlist');
              },
              child: Padding(
                padding: EdgeInsets.only(top: 4, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Container(
                        color: Color(0xff666666),
                        width: 40,
                        height: 40,
                        child: CachedNetworkImage(
                          imageUrl: playList[index]['coverImgUrl'],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                playList[index]['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            box,
                            Text(
                              '${playList[index]['trackCount']}首',
                              textAlign: TextAlign.left,
                              style: listRight,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.more_vert,
                        color: rightColor,
                      ),
                    ),
                  ],
                ),
              ),
            );

            if (playList[index]['creator']['userId'].toString() == _userId) {
              playListWifget.add(child);
            } else {
              collectWifget.add(child);
            }
          }
        });
      } else {
        WeToast.fail(context)(message: '获取歌单失败');
      }
    } catch (e) {
      WeToast.fail(context)(message: '未知错误');
      print(e);
    }
  }

  _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.get('userId');
  }

  @override
  void initState() {
    super.initState();
    _getUserId();
    getSongList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    const channels = [
      {
        'title': 'ACG专区',
        'icon': const Icon(
          Icons.brightness_auto,
          color: Colors.white,
        ),
      },
      {
        'title': '最嗨电音',
        'icon': const Icon(
          Icons.grain,
          color: Colors.white,
        ),
      },
      {
        'title': 'Sati空间',
        'icon': const Icon(
          Icons.brightness_2,
          color: Colors.white,
        ),
      },
      {
        'title': '私藏推荐',
        'icon': const Icon(
          Icons.folder_special,
          color: Colors.white,
        ),
      },
      {
        'title': '因乐交友',
        'icon': const Icon(
          Icons.supervised_user_circle,
          color: Colors.white,
        ),
      },
      {
        'title': '亲子频道',
        'icon': const Icon(
          Icons.child_friendly,
          color: Colors.white,
        ),
      },
      {
        'title': '古典专区',
        'icon': const Icon(
          Icons.queue_music,
          color: Colors.white,
        ),
      },
    ];

    List<Widget> children = [];

    for (int index = 0; index < channels.length; index++) {
      children.add(Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        color: Colors.red,
                        child: channels[index]['icon'])),
                box,
                Text(
                  channels[index]['title'],
                  style: TextStyle(fontSize: 12.0),
                ),
              ],
            ),
          ),
        ),
      ));
    }

    final home = store.state.playState['home'];

    return StoreConnector<PlayState, Map>(
        converter: (store) => home,
        builder: (context, play) {
          if (playList.length != home['songlist'].length) {
            playList = home['songlist'];
            for (int index = 0; index < playList.length; index++) {
              Widget child = InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString(
                      'playlistId', playList[index]['id'].toString());
                  Navigator.of(context).pushNamed('/playlist');
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 4, bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Container(
                          color: Color(0xff666666),
                          width: 40,
                          height: 40,
                          child: CachedNetworkImage(
                            imageUrl: playList[index]['coverImgUrl'],
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  playList[index]['name'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              box,
                              Text(
                                '${playList[index]['trackCount']}首',
                                textAlign: TextAlign.left,
                                style: listRight,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.more_vert,
                          color: rightColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
              if (playList[index]['creator']['userId'].toString() == _userId) {
                playListWifget.add(child);
              } else {
                collectWifget.add(child);
              }
            }
          }
          return Scaffold(
            body: IndexedStack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            height: 110,
                            color: Colors.white,
                            // .Side(color: Color(0xFFe0e0e0), width: 0.5))),
                            child: Row(
                              children: children,
                            ),
                          ),
                        ),
                        Container(
                          child: WeCells(boxBorder: true, children: [
                            WeCell(
                                label: Row(children: <Widget>[
                                  Padding(
                                      child: Icon(Icons.queue_music),
                                      padding: EdgeInsets.only(right: 12)),
                                  Text(
                                    '本地音乐',
                                    style: _listFont,
                                  )
                                ]),
                                content: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        '0',
                                        style: listRight,
                                      ),
                                      Padding(
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 18,
                                            color: rightColor,
                                          ),
                                          padding: EdgeInsets.only(left: 2)),
                                    ])),
                            WeCell(
                                label: Row(children: <Widget>[
                                  Padding(
                                      child: Icon(Icons.play_circle_outline),
                                      padding: EdgeInsets.only(right: 12)),
                                  Text(
                                    '最近播放',
                                    style: _listFont,
                                  )
                                ]),
                                content: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        userInfo['subPlaylistCount'] == null
                                            ? '0'
                                            : userInfo['subPlaylistCount']
                                                .toString(),
                                        style: listRight,
                                      ),
                                      Padding(
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 18,
                                            color: rightColor,
                                          ),
                                          padding: EdgeInsets.only(left: 2)),
                                    ])),
                            WeCell(
                                label: Row(children: <Widget>[
                                  Padding(
                                      child: Icon(Icons.radio),
                                      padding: EdgeInsets.only(right: 12)),
                                  Text(
                                    '我的电台',
                                    style: _listFont,
                                  )
                                ]),
                                content: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        userInfo['djRadioCount'] == null
                                            ? '0'
                                            : userInfo['djRadioCount']
                                                .toString(),
                                        style: listRight,
                                      ),
                                      Padding(
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 18,
                                            color: rightColor,
                                          ),
                                          padding: EdgeInsets.only(left: 2)),
                                    ])),
                            WeCell(
                                label: Row(children: <Widget>[
                                  Padding(
                                      child: Icon(Icons.star_border),
                                      padding: EdgeInsets.only(right: 12)),
                                  Text(
                                    '我的收藏',
                                    style: _listFont,
                                  )
                                ]),
                                content: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        '0',
                                        style: listRight,
                                      ),
                                      Padding(
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 18,
                                            color: rightColor,
                                          ),
                                          padding: EdgeInsets.only(left: 2)),
                                    ]))
                          ]),
                        ),
                        box,
                        WeCollapse(defaultActive: [
                          '0'
                        ], children: [
                          WeCollapseItem(
                              title: Row(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '我创建的歌单',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "(${playListWifget.length})",
                                        style: listRight,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              child: Column(
                                children: playListWifget,
                              )),
                          WeCollapseItem(
                              title: Row(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '我收藏的歌单',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "(${collectWifget.length})",
                                        style: listRight,
                                      )
                                    ],
                                  )
                                ],
                              ),
                              child: Column(
                                children: collectWifget,
                              ))
                        ]),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
