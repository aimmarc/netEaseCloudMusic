import 'package:flutter/material.dart';
import 'package:flutter_app/components/play_bar.dart';
import 'package:flutter_app/views/new_song_item.dart';

class NewSongPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: choices.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('新歌速递'),
          elevation: 1,
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
  const Choice({this.title, this.component});
  final String title;
  final String component;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '推荐', component: 'top'),
  const Choice(title: '华语', component: 'cn'),
  const Choice(title: '欧美', component: 'eu'),
  const Choice(title: '韩国', component: 'kora'),
  const Choice(title: '日本', component: 'jp'),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    switch (choice.component) {
      case 'top':
        return NewSongItemPage(0);
        break;
      case 'cn':
        return NewSongItemPage(7);
        break;
      case 'eu':
        return NewSongItemPage(96);
        break;
      case 'kora':
        return NewSongItemPage(16);
        break;
      case 'jp':
        return NewSongItemPage(8);
        break;
      default:
        return NewSongItemPage(0);
        ;
        break;
    }
  }
}
