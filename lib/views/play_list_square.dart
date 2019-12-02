import 'package:flutter/material.dart';
import 'package:flutter_app/components/play_bar.dart';
import '../views/play_list_popular.dart';
import 'play_list_top.dart';

class SquarePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: choices.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text('歌单广场'),
          bottom: TabBar(
            isScrollable: true,
            tabs: choices.map((Choice choice) {
              return Tab(
                text: choice.title,
              );
            }).toList(),
          ),
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
  const Choice(title: '精品', icon: Icons.directions_car, component: 'top'),
  const Choice(title: '华语', icon: Icons.directions_bike, component: 'cn'),
  const Choice(title: '流行', icon: Icons.directions_boat, component: 'popular'),
  const Choice(title: '轻音乐', icon: Icons.directions_boat, component: 'light'),
  const Choice(title: 'ACG', icon: Icons.directions_boat, component: 'acg'),
  const Choice(title: '民谣', icon: Icons.directions_boat, component: 'valige'),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    switch (choice.component) {
      case 'top':
        return PlayTopPage();
        break;
      case 'cn':
        return PlayPopularPage('华语');
        break;
      case 'popular':
        return PlayPopularPage('流行');
        break;
      case 'light':
        return PlayPopularPage('轻音乐');
        break;
      case 'acg':
        return PlayPopularPage('ACG');
        break;
      case 'valige':
        return PlayPopularPage('民谣');
        break;
      default:
        return PlayTopPage();
        break;
    }
  }
}
