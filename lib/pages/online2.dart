import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class online2 extends StatefulWidget {
  online2({Key key}) : super(key: key);

  @override
  _online2State createState() => _online2State();
}

Future<void> getDatos() async {
  var response = await http.get("https://musiclyapi.herokuapp.com/musicAll");

  return response.body;
}

class _online2State extends State<online2> {
  bool play;
  var music;
  var musicPlaying;
  List<Audio> musicPlaylist = [];
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    setState(() {
      play = false;
      music = getDatos();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: music,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          Map data = json.decode(snapshot.data);
          List datos = data['music'];
          for (var i = 0; i < datos.length; i++) {
            musicPlaylist.add(Audio.network(
                "https://musiclyapi.herokuapp.com/music/${datos[i]['ruta']}",
                metas: Metas(
                    title: datos[i]['name'],
                    artist: datos[i]['autor'],
                    album: datos[i]['album'])));
          }
          return audioPlayer.builderIsPlaying(builder: (context, playing) {
            if (playing) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  play = playing;
                });
              });
            }
            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: Column(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: () {
                      audioPlayer.open(
                        Playlist(
                          audios: musicPlaylist,
                        ),
                        showNotification: true,
                        loopMode: LoopMode.playlist,
                      );
                    },
                    child: Icon(
                      Icons.playlist_play,
                      size: 45.0,
                      color: Colors.greenAccent,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        height: size.height * .7,
                        child: ListView.builder(
                          itemCount: datos.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 120.0,
                                height: 90,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.green.withOpacity(.5),
                                        blurRadius: 12.0)
                                  ],
                                ),
                                child: Card(
                                  color: Colors.grey,
                                  elevation: 22.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              child: Image.asset(
                                                  "assets/icon/icon.png"),
                                            ),
                                            Spacer(),
                                            Container(
                                              width: 160,
                                              child: Text(
                                                datos[index]['name'],
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.greenAccent),
                                              ),
                                            ),
                                            Spacer(),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7.0),
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Icon(
                                                      Icons.playlist_add,
                                                      color: Colors.pinkAccent,
                                                      size: 28),
                                                )),
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(45),
                                                  color: Colors.greenAccent),
                                              child: audioPlayer
                                                          .current
                                                          .value
                                                          .audio
                                                          .assetAudioPath ==
                                                      "https://musiclyapi.herokuapp.com/music/${datos[index]['ruta']}"
                                                  ? playing == false
                                                      ? InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              play = true;
                                                              musicPlaying =
                                                                  index;
                                                            });

                                                            if (playing ==
                                                                true) {
                                                              audioPlayer
                                                                  .stop();
                                                            } else {
                                                              if (musicPlaying ==
                                                                  index) {
                                                                audioPlayer
                                                                    .playOrPause();
                                                              } else {
                                                                audioPlayer.open(
                                                                    Audio.network(
                                                                        "https://musiclyapi.herokuapp.com/music/${datos[index]['ruta']}",
                                                                        metas: Metas(
                                                                            title: datos[index][
                                                                                'name'],
                                                                            artist: datos[index][
                                                                                'autor'],
                                                                            album: datos[index][
                                                                                'album'])),
                                                                    showNotification:
                                                                        true);
                                                              }
                                                            }
                                                          },
                                                          child: Icon(
                                                              Icons.play_arrow,
                                                              size: 35.0))
                                                      : InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              play = false;
                                                            });
                                                          },
                                                          child: Icon(
                                                              Icons.pause,
                                                              size: 35.0))
                                                  : InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          play = false;
                                                        });
                                                      },
                                                      child: Icon(
                                                          Icons.play_arrow,
                                                          size: 35.0)),
                                            ),
                                          ],
                                        ),
                                        playing == true &&
                                                audioPlayer.current.value.audio
                                                        .assetAudioPath ==
                                                    "https://musiclyapi.herokuapp.com/music/${datos[index]['ruta']}"
                                            ? audioPlayer
                                                .builderRealtimePlayingInfos(
                                                    builder: (context, infos) {
                                                if (infos.duration == null) {
                                                  return LinearProgressIndicator();
                                                }
                                                if (audioPlayer.current.value
                                                        .audio.assetAudioPath ==
                                                    "https://musiclyapi.herokuapp.com/music/${datos[index]['ruta']}") {
                                                  return Expanded(
                                                    child: Slider(
                                                      max: infos
                                                          .duration.inSeconds
                                                          .toDouble(),
                                                      value: infos
                                                          .currentPosition
                                                          .inSeconds
                                                          .toDouble(),
                                                      onChanged:
                                                          (double value) {
                                                        audioPlayer.seek(
                                                            Duration(
                                                                seconds: value
                                                                    .toInt()));
                                                      },
                                                      activeColor:
                                                          Colors.cyanAccent,
                                                    ),
                                                  );
                                                } else {
                                                  Expanded(
                                                    child: Slider(
                                                      max: 25,
                                                      value: 0,
                                                      onChanged: null,
                                                      activeColor:
                                                          Colors.cyanAccent,
                                                    ),
                                                  );
                                                }
                                              })
                                            : Expanded(
                                                child: Slider(
                                                  max: 25,
                                                  value: 0,
                                                  onChanged: null,
                                                  activeColor:
                                                      Colors.cyanAccent,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
        }
      },
    );
  }
}
