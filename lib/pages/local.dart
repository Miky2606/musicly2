import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'bottoms/playlist.dart';
import 'bottoms/playlist.dart';
import 'bottoms/playlist.dart';
import 'bottoms/playlist.dart';

class local extends StatefulWidget {
  local({Key key}) : super(key: key);

  @override
  _localState createState() => _localState();
}

class _localState extends State<local> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text("Tus Playlists")),
          ),
          Divider(),
          Container(
            height: 200.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Row(
                  children: [playlist(), playlist(), playlist(), playlist()],
                )
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text("Playlists mas Escuchados")),
          ),
          Container(
            height: 200.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Row(
                  children: [playlist(), playlist(), playlist(), playlist()],
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
