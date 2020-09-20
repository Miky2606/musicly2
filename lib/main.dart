import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicly/pages/online.dart';
import 'package:musicly/pages/local.dart';
import 'package:musicly/pages/online2.dart';
import 'package:musicly/pages/playlistHome.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.dark, primaryColor: Colors.grey[900]),
        title: 'MusicLi',
        home: scaffold());
  }
}

class scaffold extends StatefulWidget {
  scaffold({Key key}) : super(key: key);

  @override
  _scaffoldState createState() => _scaffoldState();
}

int _currentIndex = 0;

class _scaffoldState extends State<scaffold> {
  @override
  Widget build(BuildContext context) {
    final tabs = [online(), local(), playlistHome()];

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.all(128.0),
          child: Center(
            child: Image.asset(
              'assets/icon/icon.png',
              width: size.width * .1,
              height: size.height * .2,
            ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
          color: Colors.grey[900],
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Colors.grey.withOpacity(.5),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            Icon(Icons.home, color: Colors.white, size: 35),
            Icon(Icons.music_note),
            Icon(Icons.library_music, color: Colors.white, size: 35),
          ]),
      body: tabs[_currentIndex],
    );
  }
}
