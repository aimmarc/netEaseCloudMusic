import 'package:flutter/material.dart';
import '../views/new_song.dart';
import '../views/day_push.dart';
import '../views/play_list_square.dart';
import '../views/comment.dart';
import '../views/play_list.dart';
import '../views/player.dart';
import '../views/login.dart';

final routes = <String, WidgetBuilder>{
  // login
  '/login': (context) => LoginPage(),
  '/playlist': (context) => PlayListPage(),
  '/player': (context) => PlayerPage(),
  '/comment': (context) => CommentPage(),
  '/square': (context) => SquarePage(),
  '/dayPush': (context) => DayPushPage(),
  '/newSong': (context) => NewSongPage(),
};
