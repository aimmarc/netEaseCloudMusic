import 'package:flutter/material.dart';
import 'package:flutter_app/common/global.dart';
import 'package:flutter_app/components/box.dart';
import 'package:weui/weui.dart';
import 'package:dio/dio.dart';

import 'image_block.dart';

class NewDisk extends StatefulWidget {
  @override
  NewDiskState createState() => NewDiskState();
}

class NewDiskState extends State {
  var newDisks = [];

  getDisk(BuildContext context) async {
    print('发起请求');
    try {
      Map<String, dynamic> headers = new Map();
      // headers['Cookie'] = cookie;
      Options options = new Options(headers: headers);
      Response response = await Dio()
          .get("$API_PREFIX/album/newest", options: options)
          .catchError((e) {
        print(e);
        throw e;
      });
      final data = response.data;
      if (data['code'] == 200) {
        setState(() {
          newDisks = data['albums'];
        });
      } else {
        WeToast.fail(context)(message: response.data['message']);
      }
    } catch (e) {
      WeToast.fail(context)(message: '未知错误');
      //close();
      print(e);
      throw e;
    }
  }

  Widget itemBuilder(int index) {
    final item = newDisks[index];
    return SizedBox(
      height: 160.0,
      child: new Padding(
        padding: EdgeInsets.only(top: 0, bottom: 16, left: 8, right: 8),
        child: ImageBlock(item),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getDisk(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: newDisks.length > 0
          ? Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '新碟',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        flex: 1,
                      ),
                      WeButton('更多新碟', size: WeButtonSize.mini),
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
                      itemBuilder: itemBuilder),
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
}
