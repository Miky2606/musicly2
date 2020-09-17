import 'dart:convert';

import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/services.dart';
import 'package:musicly/pages/bottoms/playlist.dart';
import 'package:musicly/pages/displayMusic/DisplayMusic.dart';
import 'package:http/http.dart' as http;
import 'package:assets_audio_player/assets_audio_player.dart';

bool pause;
var playing;
var name;
var player;

class online extends StatefulWidget {
  online({Key key}) : super(key: key);

  @override
  _onlineState createState() => _onlineState();
}

class _onlineState extends State<online> {
  String _platformVersion = 'Unknown';
  Duration _duration;
  Duration _position;
  void initState() {
    super.initState();

    /* initPlatformState();
    audio(); */
    // loadFile();
  }

  /*  audio() {
    AudioManager.instance.onEvents((events, args) {
      switch (events) {
        case AudioManagerEvents.ready:
          _position = AudioManager.instance.position;
          _duration = AudioManager.instance.duration;
          print(_duration);

          if (_position == null) {
            print("yes");
          }
          break;
        case AudioManagerEvents.playstatus:
          var _playing = AudioManager.instance.isPlaying;

          break;
        case AudioManagerEvents.next:
          break;
        case AudioManagerEvents.timeupdate:
          setState(() {
            _position = AudioManager.instance.position;
          });
          if (_position == null) {
            print("yes");
          }
          break;
      }
    });
  } */

  /*  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await AudioManager.instance.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  } */

  @override
  Widget build(BuildContext context) {
    final scaffold = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffold,
      body: ListView(children: [
        Container(
          height: 220.0,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              Row(children: [playlist(), playlist(), playlist()]),
            ],
          ),
        ),
        Divider(
          height: 12.0,
          color: Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text("Hola")),
        ),
        ListMusic(),
      ]),
    );
  }
}

//ListMusic

class ListMusic extends StatefulWidget {
  const ListMusic({Key key}) : super(key: key);

  @override
  _ListMusicState createState() => _ListMusicState();
}

Future<void> getDatos() async {
  var response = await http.get("https://musiclyapi.herokuapp.com/musicAll");
  print(response.body);

  return response.body;
}

class _ListMusicState extends State<ListMusic> {
  final assets = AssetsAudioPlayer();
  var music;
  bool _inPlay;
  @override
  void initState() {
    super.initState();
    setState(() {
      music = getDatos();
      _inPlay = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: music,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map data = json.decode(snapshot.data);
          List datos = data['music'];

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Container(
                    height: 180,
                    child: ListView.builder(
                        itemCount: datos.length,
                        itemBuilder: (BuildContext context, index) {
                          return InkWell(
                            onTap: () {
                              _play(index, datos);
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                        child: Image.asset(
                                            "assets/icon/icon.png")),
                                    Spacer(),
                                    Expanded(
                                      child: Text(
                                        "${datos[index]['name']}",
                                      ),
                                    ),
                                    Spacer(),

                                    /* //Buttons(
                                      notifyParent: refresh,
                                        
                                        music: datos,
                                        active: index), */
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
              ),
            ],
          );
        } else {
          return Text("be");
        }
      },
    );

    /* */
  }

  void _play(active, music) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DisplayMusic(
            player: assets,
            name: music[active]['name'],
            music: active,
            lista: music,
            play: _inPlay)));

/*     var x = true;
    if (x == true) {
     
    } */

    /*  AudioManager.instance
        .start(
            "https://musiclyapi.herokuapp.com/music/${music[active]['ruta']}",
            // "network format resource"
            // "local resource (file://${file.path})"
            "${music[active]['name']}",
            desc: "desc",
            // cover: "network cover image resource"
            cover: "assets/icon/icon.png")
        .then((err) {
      print(err);
    });
 */
  }

  @override
  void dispose() {
    // 释放所有资源
    AudioManager.instance.stop();
    super.dispose();
  }
}

//Buttons

class Buttons extends StatefulWidget {
  final music;
  final active;
  const Buttons({Key key, this.music, this.active}) : super(key: key);

  @override
  _ButtonsState createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  Duration position = Duration();
  var id;
  int duration;

  @override
  void initState() {
    super.initState();
    setState(() {
      id = "";
      duration = 365;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        InkWell(
            onTap: () {
              //_play(widget.active, widget.music);
            },
            child: Icon(Icons.play_arrow)),
      ]),
    );
  }

  void _play(active, music) async {
    var play = await player.setAsset('assets/${music[active]['song']}');
    player.play();
  }
}

//playlist

class ButtonsBottom extends StatefulWidget {
  final music;
  final musicActive;
  final play;
  ButtonsBottom({Key key, this.music, this.musicActive, this.play})
      : super(key: key);

  @override
  _ButtonsBottomState createState() => _ButtonsBottomState();
}

class _ButtonsBottomState extends State<ButtonsBottom> {
  @override
  void initState() {
    super.initState();
    setState(() {
      pause = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        InkWell(onTap: () {}, child: Icon(Icons.fast_rewind)),
        pause == true
            ? InkWell(
                onTap: () {
                  print("pause");
                  setState(() {
                    pause = false;
                  });
                  widget.play.pause();
                },
                child: Icon(Icons.pause))
            : InkWell(
                onTap: () {
                  print("play ");
                  setState(() {
                    pause = true;
                  });
                  widget.play.play();
                },
                child: Icon(Icons.play_arrow)),
        InkWell(onTap: () {}, child: Icon(Icons.fast_forward)),
      ]),
    );
  }
}
