import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../online2.dart';

class playlist extends StatefulWidget {
  const playlist({
    Key key,
  }) : super(key: key);

  @override
  _playlistState createState() => _playlistState();
}

class _playlistState extends State<playlist> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => online2()));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.grey[700],
          ),
          height: 220,
          width: 160,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Text("playlistName")),
              ),
              FlareActor(
                "assets/animation/music.flr",
                animation: "Hover",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
