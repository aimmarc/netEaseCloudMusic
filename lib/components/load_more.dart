import 'package:flutter/material.dart';

class LoadMore extends StatelessWidget {
  bool loading = false;
  String text;
  LoadMore(this.loading, this.text);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          loading
              ? SizedBox(
                  width: 16.0,
                  height: 16.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Container(),
          loading
              ? Padding(
                  padding: EdgeInsets.only(left: 10),
                )
              : Container(),
          Text(text == null ? '加载中...' : text),
        ],
      ),
    );
  }
}
