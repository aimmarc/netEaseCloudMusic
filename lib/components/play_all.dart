import 'package:flutter/material.dart';

class PlayAll extends StatelessWidget {
  String count;
  PlayAll(this.count);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Icon(Icons.play_circle_outline),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.0),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('播放全部'),
                  Text(
                    '（共${count}首）',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Color(0xff999999),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
