import 'package:flutter/material.dart';

class playlist extends StatefulWidget {
  playlist({Key key}) : super(key: key);

  @override
  _playlistState createState() => _playlistState();
}

class _playlistState extends State<playlist> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("playlist")),
    );
  }
}
