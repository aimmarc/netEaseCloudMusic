import 'package:flutter/material.dart';
import 'package:flutter_app/common/global.dart';
import 'package:flutter_app/components/box.dart';
import 'package:flutter_app/util/request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weui/button/index.dart';
import 'package:weui/cell/index.dart';
import 'package:weui/weui.dart';

class DrawerContent extends StatefulWidget {
  @override
  DrawerContentState createState() => DrawerContentState();
}

class DrawerContentState extends State {
  var fontstyle = TextStyle(fontSize: 12.0, color: Color(0xff999999));
  var listFont = const TextStyle(fontSize: 14.0);
  var rightColor = Color(0xff666666);
  var listRight = const TextStyle(fontSize: 12.0, color: Color(0xff999999));
  var isLogin = false;
  var userInfo = {};

  // 获取登录状态
  loginState(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.get('userId');
    print(prefs.get('level'));
    if (userId != null) {
      setState(() {
        isLogin = true;
        userInfo['avatarUrl'] = prefs.get('avatarUrl');
        userInfo['nickname'] = prefs.get('nickname');
      });
    } else {
      isLogin = false;
    }
  }

  @override
  void initState() {
    super.initState();
    loginState(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                Container(
                  height: 180,
                  // width: 300,
                  padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                  color: Color(0xffe0e0e0),
                  child: isLogin
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  child: new ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: Image(
                                        height: 60.0,
                                        fit: BoxFit.cover,
                                        image:
                                            NetworkImage(userInfo['avatarUrl']),
                                      )),
                                )),
                            box,
                            box,
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: Row(
                                  children: <Widget>[
                                    Text(userInfo['nickname']),
                                    Container(
                                      margin: EdgeInsets.only(left: 4.0),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 4.0, right: 4.0),
                                            color: Color(0xffd0d0d0),
                                            child: Text(
                                              'Lv.9',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Color(0xff999999),
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          )),
                                    )
                                  ],
                                )),
                                new ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: WeButton(
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.create,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 4),
                                            child: Text('签到'),
                                          )
                                        ],
                                      ),
                                      size: WeButtonSize.mini,
                                      theme: WeButtonType.warn),
                                )
                              ],
                            )
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            Text(
                              '登录网易云音乐',
                              style: TextStyle(color: Color(0xff666666)),
                            ),
                            box,
                            Text(
                              '手机电脑多端同步，尽享海量高品质音乐',
                              style: TextStyle(color: Color(0xff666666)),
                            ),
                            box,
                            box,
                            WeButton(
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Text(
                                  '立即登录',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ),
                              size: WeButtonSize.mini,
                              onClick: () {
                                Navigator.of(context).pushNamed('/login');
                              },
                            )
                          ],
                        ),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.mail_outline,
                                  color: Theme.of(context).accentColor,
                                  size: 28,
                                ),
                                box,
                                Text(
                                  '我的消息',
                                  style: fontstyle,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.person_outline,
                                  color: Theme.of(context).accentColor,
                                  size: 28,
                                ),
                                box,
                                Text(
                                  '我的好友',
                                  style: fontstyle,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.mic,
                                  color: Theme.of(context).accentColor,
                                  size: 28,
                                ),
                                box,
                                Text(
                                  '听歌识曲',
                                  style: fontstyle,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.toys,
                                  color: Theme.of(context).accentColor,
                                  size: 28,
                                ),
                                box,
                                Text(
                                  '个性装扮',
                                  style: fontstyle,
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ),
                WeCells(
                  boxBorder: true,
                  children: <Widget>[
                    WeCell(
                        label: Row(children: <Widget>[
                          Padding(
                              child: Icon(
                                Icons.movie_filter,
                                color: rightColor,
                              ),
                              padding: EdgeInsets.only(right: 10)),
                          Text(
                            '演出',
                            style: listFont,
                          )
                        ]),
                        content: Text(
                          '李荣浩巡演',
                          style: listRight,
                        )),
                    WeCell(
                        label: Row(children: <Widget>[
                      Padding(
                          child: Icon(
                            Icons.shopping_cart,
                            color: rightColor,
                          ),
                          padding: EdgeInsets.only(right: 10)),
                      Text(
                        '商城',
                        style: listFont,
                      )
                    ])),
                    WeCell(
                        label: Row(children: <Widget>[
                      Padding(
                          child: Icon(
                            Icons.location_on,
                            color: rightColor,
                          ),
                          padding: EdgeInsets.only(right: 10)),
                      Text(
                        '附近的人',
                        style: listFont,
                      )
                    ])),
                    WeCell(
                        label: Row(children: <Widget>[
                      Padding(
                          child: Icon(
                            Icons.notifications_none,
                            color: rightColor,
                          ),
                          padding: EdgeInsets.only(right: 10)),
                      Text(
                        '口袋彩铃',
                        style: listFont,
                      )
                    ])),
                  ],
                ),
                WeCells(boxBorder: false, children: <Widget>[
                  WeCell(
                      label: Row(children: <Widget>[
                    Padding(
                        child: Icon(
                          Icons.lightbulb_outline,
                          color: rightColor,
                        ),
                        padding: EdgeInsets.only(right: 10)),
                    Text(
                      '创作者中心',
                      style: listFont,
                    )
                  ])),
                ]),
                WeCells(
                  boxBorder: true,
                  children: <Widget>[
                    WeCell(
                        label: Row(children: <Widget>[
                      Padding(
                          child: Icon(
                            Icons.assignment,
                            color: rightColor,
                          ),
                          padding: EdgeInsets.only(right: 10)),
                      Text(
                        '我的订单',
                        style: listFont,
                      )
                    ])),
                    WeCell(
                        label: Row(children: <Widget>[
                      Padding(
                          child: Icon(
                            Icons.alarm_on,
                            color: rightColor,
                          ),
                          padding: EdgeInsets.only(right: 10)),
                      Text(
                        '定时停止播放',
                        style: listFont,
                      )
                    ])),
                    WeCell(
                        label: Row(children: <Widget>[
                      Padding(
                          child: Icon(
                            Icons.center_focus_weak,
                            color: rightColor,
                          ),
                          padding: EdgeInsets.only(right: 10)),
                      Text(
                        '扫一扫',
                        style: listFont,
                      )
                    ])),
                    WeCell(
                        label: Row(children: <Widget>[
                      Padding(
                          child: Icon(
                            Icons.cloud_queue,
                            color: rightColor,
                          ),
                          padding: EdgeInsets.only(right: 10)),
                      Text(
                        '音乐云盘',
                        style: listFont,
                      )
                    ])),
                    WeCell(
                        label: Row(children: <Widget>[
                      Padding(
                          child: Icon(
                            Icons.card_giftcard,
                            color: rightColor,
                          ),
                          padding: EdgeInsets.only(right: 10)),
                      Text(
                        '优惠券',
                        style: listFont,
                      )
                    ])),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: 50,
          decoration: new BoxDecoration(
              border: new Border(
                  top: BorderSide(color: Color(0xFFe0e0e0), width: 0.5))),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.brightness_2,
                      size: 18,
                      color: rightColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Text('夜间模式'),
                    )
                  ],
                ),
                flex: 1,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.settings,
                      size: 18,
                      color: rightColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Text('设置'),
                    )
                  ],
                ),
                flex: 1,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    print('object');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.exit_to_app,
                        size: 18,
                        color: rightColor,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Text('退出'),
                      )
                    ],
                  ),
                ),
                flex: 1,
              ),
            ],
          ),
        )
      ],
    ));
  }
}
