import 'package:flutter/material.dart';
import 'package:flutter_app/components/drawer_content.dart';
import 'package:flutter_app/components/play_bar.dart';
import '../views/home.dart';
import '../views/find.dart';
import '../views/cloud_valige.dart';

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: choices.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: TabBar(
            isScrollable: true,
            tabs: choices.map((Choice choice) {
              return Tab(
                text: choice.title,
                //icon: new Icon(choice.icon),
              );
            }).toList(),
          ),
          actions: <Widget>[
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  //color: Theme.of(context).primaryColor,
                ))
          ],
        ),
        drawer: Drawer(
          child: DrawerContent(),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TabBarView(
                children: choices.map((Choice choice) {
                  return ChoiceCard(choice: choice);
                }).toList(),
              ),
            ),
            PlayBar(),
          ],
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon, this.component});
  final String title;
  final IconData icon;
  final String component;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '我的', icon: Icons.directions_car, component: 'home'),
  const Choice(title: '发现', icon: Icons.directions_bike, component: 'find'),
  const Choice(
      title: '云村', icon: Icons.directions_boat, component: 'cloud_valige'),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    switch (choice.component) {
      case 'home':
        return HomePage();
        break;
      case 'find':
        return FindPage();
        break;
      case 'cloud_valige':
        return CloudValigePage();
        break;
      default:
        return HomePage();
        break;
    }
  }
}
