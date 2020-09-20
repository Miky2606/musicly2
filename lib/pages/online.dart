import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class online extends StatefulWidget {
  online({Key key}) : super(key: key);

  @override
  _onlineState createState() => _onlineState();
}

class _onlineState extends State<online> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 250.0,
                  child: FadeAnimatedTextKit(
                      onTap: () {
                        print("Tap Event");
                      },
                      text: ["Sube", "Crea", "Escucha"],
                      textStyle: TextStyle(
                          fontSize: 32.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      alignment:
                          AlignmentDirectional.topCenter // or Alignment.topLeft
                      ),
                ),
              ),
            ),
            FlareActor(
              "assets/animation/music.flr",
              animation: "Hover",
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                    onTap: () {},
                    child:
                        RaisedButton(onPressed: () {}, child: Text("Crear")))),
          ],
        ),
      ),
    );
  }
}
