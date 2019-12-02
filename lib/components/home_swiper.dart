import 'package:flutter/material.dart';
import 'package:flutter_app/common/global.dart';
import 'package:weui/weui.dart';
import 'package:dio/dio.dart';

class HomeSwiper extends StatefulWidget {
  @override
  HomeSwiperState createState() => HomeSwiperState();
}

class HomeSwiperState extends State {
  var banners = [];

  getBanner(BuildContext context) async {
    print('发起请求');
    try {
      Response response = await Dio()
          .get("$API_PREFIX/banner?type=2")
          .catchError((e) {
        print(e);
        throw e;
      });
      final data = response.data;
      if (data['code'] == 200) {
        setState(() {
          banners = data['banners'];
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
    return Container(
        // color: index % 2 == 0 ? Color(0xff39a9ed) : Color(0xff66c6f2),
        child: Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image(
                //height: 130.0,
                fit: BoxFit.cover,
                image: NetworkImage(banners[index]['pic']),
              ),
            )));
  }

  @override
  void initState() {
    super.initState();
    getBanner(context);
  }

  @override
  Widget build(BuildContext context) {
    return banners.length > 0
        ? new WeSwipe(
            autoPlay: true,
            height: 130.0,
            itemCount: banners.length,
            itemBuilder: itemBuilder)
        : new Container(
            height: 130,
            child: new WeSpin(
              isShow: true,
              tip: Text('加载中...'),
            ),
          );
  }
}
