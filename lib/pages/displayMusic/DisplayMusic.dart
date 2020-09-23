import 'dart:convert';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class DisplayMusic extends StatefulWidget {
  DisplayMusic({Key key}) : super(key: key);

  @override
  _DisplayMusicState createState() => _DisplayMusicState();
}

Future<void> getDatos() async {
  var response = await http.get("https://musiclyapi.herokuapp.com/musicAll");

  return response.body;
}

class _DisplayMusicState extends State<DisplayMusic> {
  bool play;
  String audio;
  var music;
  var musicPlaying;
  List<Audio> musicPlaylist = [];
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    setState(() {
      play = false;
      music = getDatos();
      audio = "";
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
                      album: datos[i]['album'],
                      image: MetasImage.asset("assets/icon/icon.png"))));
            }
            audioPlayer.open(
              Playlist(
                audios: musicPlaylist,
              ),
              showNotification: true,
              loopMode: LoopMode.playlist,
            );

            return Scaffold(
              body: Container(
                decoration: BoxDecoration(),
                height: size.height,
                child: ListView(
                  children: [
                    Text("playlistName"),
                    Container(
                        height: size.height,
                        child: Stack(children: [
                          FlareActor("assets/animation/aura.flr"),
                          ListView.builder(
                              itemCount: datos.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(children: [
                                            CircleAvatar(
                                                child: Image.asset(
                                                    "assets/icon/icon.png")),
                                            Spacer(),
                                            Text("name"),
                                            Spacer(),
                                            audioPlayer.builderCurrent(
                                                builder: (context, current) {
                                              if (current == null) {
                                                return InkWell(
                                                    onTap: () {
                                                      audioPlayer
                                                          .playlistPlayAtIndex(
                                                              index);
                                                    },
                                                    child:
                                                        Icon(Icons.play_arrow));
                                              } else {
                                                return audioPlayer
                                                    .builderIsPlaying(builder:
                                                        (context, playing) {
                                                  if (audioPlayer
                                                          .current
                                                          .value
                                                          .playlist
                                                          .currentIndex ==
                                                      index) {
                                                    if (playing == false) {
                                                      return InkWell(
                                                          onTap: () {
                                                            audioPlayer
                                                                .playOrPause();
                                                          },
                                                          child: Icon(Icons
                                                              .play_arrow));
                                                    } else {
                                                      return InkWell(
                                                          onTap: () {
                                                            audioPlayer
                                                                .playOrPause();
                                                          },
                                                          child: Icon(
                                                              Icons.pause));
                                                    }
                                                  } else {
                                                    return InkWell(
                                                        onTap: () {
                                                          audioPlayer
                                                              .playlistPlayAtIndex(
                                                                  index);
                                                        },
                                                        child: Icon(
                                                            Icons.play_arrow));
                                                  }
                                                });
                                              }
                                            }),
                                            Icon(Icons.more_vert)
                                          ]),
                                          audioPlayer.builderCurrent(
                                              builder: (context, current) {
                                            if (current == null) {
                                              return Slider(
                                                max: 25,
                                                value: 0,
                                                onChanged: null,
                                                activeColor: Colors.cyanAccent,
                                              );
                                            } else {
                                              return audioPlayer
                                                  .builderRealtimePlayingInfos(
                                                      builder:
                                                          (context, infos) {
                                                if (infos == null) {
                                                  return LinearProgressIndicator();
                                                } else {
                                                  if (audioPlayer
                                                          .current
                                                          .value
                                                          .playlist
                                                          .currentIndex ==
                                                      index) {
                                                    return Slider(
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
                                                    );
                                                  } else {
                                                    return Slider(
                                                      max: 25,
                                                      value: 0,
                                                      onChanged: null,
                                                      activeColor:
                                                          Colors.cyanAccent,
                                                    );
                                                  }
                                                }
                                              });
                                            }
                                          })
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ])),
                  ],
                ),
              ),
            );
          }
        });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
