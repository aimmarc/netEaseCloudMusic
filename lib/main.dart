import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/redux/index.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import './views/index.dart';
import './router/index.dart';
import 'package:weui/weui.dart';

final store = Store<PlayState>(reducer, initialState: PlayState.initState());

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(App(store));
}
// void main() => Global.init().then((e) => runApp(App()));

class App extends StatefulWidget {
  final Store<PlayState> store;
  App(this.store);
  @override
  AppState createState() => AppState();
}

class AppState extends State {
  bool isDefaultTheme = true;

  void toggleTheme() {
    this.setState(() {
      isDefaultTheme = !isDefaultTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<PlayState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: routes,
        theme: new ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.red,
        ),
        home: IndexPage(),
      ),
    );
  }
}
