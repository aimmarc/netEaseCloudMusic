import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';

class RotateImageStatePage extends StatefulWidget {
  @override
  RotateImageState createState() => RotateImageState();
}

class RotateImageState extends State with TickerProviderStateMixin {
  AnimationController controller;

  

  void forward() {
    controller.forward(); 
  }

  void stop() {
    controller.stop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 14), vsync: this);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
        forward();
      }
    });
    forward();
  }

  @override
  Widget build(BuildContext context) {
    final play = store.state.playState;
    // TODO: implement build
    return RotationTransition(
      turns: controller,
      child: play['playingData']['imgUrl'] == null
          ? null
          : CachedNetworkImage(
              imageUrl: play['playingData']['imgUrl'],
              width: 168,
            ),
    );
  }
}
