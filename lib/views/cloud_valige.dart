import 'package:flutter/material.dart';

class CloudValigePage extends StatefulWidget {
  @override
  CloudValigePagePageState createState() => CloudValigePagePageState();
}

class CloudValigePagePageState extends State
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
        body: Container(
      child: Text('云村'),
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
