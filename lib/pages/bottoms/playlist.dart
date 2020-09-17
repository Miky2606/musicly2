import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class playlist extends StatelessWidget {
  const playlist({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
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
                  alignment: Alignment.topCenter, child: Text("playlistName")),
            ),
            FlareActor(
              "assets/animation/music.flr",
              animation: "Hover",
            ),
          ],
        ),
      ),
    );
  }
}
