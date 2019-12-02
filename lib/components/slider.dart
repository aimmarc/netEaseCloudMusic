import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';

class SliderStatePage extends StatelessWidget {
  double percent = 0.0;
  SliderStatePage(this.percent);
  @override
  Widget build(BuildContext context) {
    final play = store.state.playState;
    // TODO: implement build
    return Container(
        child: CupertinoSlider(
      value: percent,
      onChanged: (e) {
        var data = store.state.playState['playingData'];
        data['percent'] = e;
        store.dispatch({
          'type': 'setPlayingData',
          'payload': data,
        });
      },
      activeColor: Theme.of(context).accentColor,
    ));
  }
}
