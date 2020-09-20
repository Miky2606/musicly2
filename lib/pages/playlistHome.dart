import 'package:flutter/material.dart';

class playlistHome extends StatefulWidget {
  playlistHome({Key key}) : super(key: key);

  @override
  _playlistHomeState createState() => _playlistHomeState();
}

class _playlistHomeState extends State<playlistHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("playlist")),
    );
  }
}
