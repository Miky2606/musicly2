import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_manager/audio_manager.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:musicly/pages/bottoms/playlist.dart';
import 'package:musicly/pages/online.dart';

bool pause;
String nombre = "";
int index;
bool playing;
bool isPlaying;
var next;

class DisplayMusic extends StatefulWidget {
  final player;
  final name;
  final lista;
  final music;
  final play;

  DisplayMusic(
      {Key key, this.player, this.name, this.lista, this.music, this.play})
      : super(key: key);

  @override
  _DisplayMusicState createState() => _DisplayMusicState();
}

class _DisplayMusicState extends State<DisplayMusic> {
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final assets = AssetsAudioPlayer();

  @override
  void initState() {
    play();

    setState(() {
      nombre = widget.name;
      index = widget.music;
      playing = false;
      pause = true;
    });
    super.initState();
  }

  play() async {
    try {
      assets.open(
          Audio.network(
              "https://musiclyapi.herokuapp.com/music/${widget.lista[widget.music]['ruta']}",
              metas: Metas(
                  title: widget.lista[widget.music]['name'],
                  artist: widget.lista[widget.music]['autor'],
                  album: widget.lista[widget.music]['album'])),
          showNotification: true,
          audioFocusStrategy: AudioFocusStrategy.request(
              resumeAfterInterruption: true,
              resumeOthersPlayersAfterDone: true),
          notificationSettings: NotificationSettings(
            customNextAction: (player) => {forward()},
            customPrevAction: (player) => {rewind()},
            seekBarEnabled: true,
          ));
    } catch (error) {}
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text("${nombre}")),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      "assets/icon/icon.png",
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return ModalPlaylist(music: widget.name);
                            });
                      },
                      child: Icon(Icons.playlist_add))),
              PlayerBuilder.isPlaying(
                  player: assets,
                  builder: (context, playing) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        pause = playing;
                      });
                    });

                    return assets.builderRealtimePlayingInfos(
                        builder: (context, snapshot) {
                      if (snapshot == null) {
                        return LinearProgressIndicator();
                      }

                      if (snapshot.duration < snapshot.currentPosition) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            index++;
                            if (index > widget.lista.length - 1) {
                              index = 0;
                            }
                          });
                        });

                        print(index);

                        assets.open(
                            Audio.network(
                                "https://musiclyapi.herokuapp.com/music/${widget.lista[index]['ruta']}",
                                metas: Metas(
                                    title: widget.lista[index]['name'],
                                    artist: widget.lista[index]['autor'],
                                    album: widget.lista[index]['album'])),
                            showNotification: true,
                            audioFocusStrategy: AudioFocusStrategy.request(
                                resumeAfterInterruption: true,
                                resumeOthersPlayersAfterDone: true),
                            notificationSettings: NotificationSettings(
                              customNextAction: (player) => {forward()},
                              customPrevAction: (player) => {rewind()},
                              seekBarEnabled: true,
                            ));

                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            nombre = widget.lista[index]['name'];
                          });
                        });
                      }

                      return Slider(
                        max: snapshot.duration.inSeconds.toDouble(),
                        value: snapshot.currentPosition.inSeconds.toDouble(),
                        onChanged: (double value) {
                          assets.seek(Duration(seconds: value.toInt()));
                        },
                        activeColor: Colors.blue,
                        inactiveColor: Colors.purple,
                      );
                    });
                  }),

              /*  _position == null
                  ? LinearProgressIndicator()
                  : Slider(
                      max: _duration.inSeconds.toDouble(),
                      value: _position.inSeconds.toDouble(),
                      onChanged: (double value) {
                        AudioManager.instance
                            .seekTo(Duration(seconds: value.toInt()));
                      },
                      activeColor: Colors.blue,
                      inactiveColor: Colors.purple,
                    ), */
              Center(
                child: Container(
                  width: 150.0,
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            rewind();
                          },
                          child: Icon(
                            Icons.fast_rewind,
                            size: 35,
                          ),
                        ),
                        Spacer(),
                        pause == true
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    pause = false;
                                  });

                                  assets.playOrPause();
                                },
                                child: Icon(Icons.pause))
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    pause = true;
                                  });
                                  assets.playOrPause();
                                },
                                child: (Icon(Icons.play_arrow))),
                        Spacer(),
                        InkWell(
                            onTap: () async {
                              forward();
                            },
                            child: Icon(Icons.fast_forward, size: 35))
                      ],
                    ),
                  )),
                ),
              ),
            ],
          )),
    );
  }

  void next() {
    forward();
  }

  void forward() {
    setState(() {
      index++;
    });

    if (index > widget.lista.length - 1) {
      setState(() {
        index = 0;
      });
    }
    print(index);

    assets.open(
        Audio.network(
            "https://musiclyapi.herokuapp.com/music/${widget.lista[index]['ruta']}",
            metas: Metas(
                title: widget.lista[index]['name'],
                artist: widget.lista[index]['autor'],
                album: widget.lista[index]['album'])),
        showNotification: true,
        audioFocusStrategy: AudioFocusStrategy.request(
            resumeAfterInterruption: true, resumeOthersPlayersAfterDone: true),
        notificationSettings: NotificationSettings(
          customNextAction: (player) => {forward()},
          customPrevAction: (player) => {rewind()},
          seekBarEnabled: true,
        ));
    /* AudioManager.instance
            .start(
                "https://musiclyapi.herokuapp.com/music/${widget.lista[index]['ruta']}",
                // "network format resource"
                // "local resource (file://${file.path})"
                "${widget.lista[index]['ruta']}",
                desc: "desc",
                // cover: "network cover image resource"
                cover: "assets/icon/icon.png")
            .then((err) {
          print(err);
        });
 */

    setState(() {
      nombre = widget.lista[index]['name'];
    });

    /*  } else {
      setState(() {
        index++;
      });
      if (index > widget.lista.length - 1) {
        setState(() {
          index = 0;
        });
      }

      print(index);
      assets.open(
        Audio.network(
            "https://musiclyapi.herokuapp.com/music/${widget.lista[index]['ruta']}",
            metas: Metas(
                title: widget.lista[index]['name'],
                artist: widget.lista[index]['autor'],
                album: widget.lista[index]['album'])),
        showNotification: true,
      ); */
    /* AudioManager.instance
            .start(
                "https://musiclyapi.herokuapp.com/music/${widget.lista[index]['ruta']}",
                // "network format resource"
                // "local resource (file://${file.path})"
                "${widget.lista[index]['name']}",
                desc: "desc",
                // cover: "network cover image resource"
                cover: "assets/icon/icon.png")
            .then((err) {
          print(err);
        });
 */
    /*  setState(() {
        nombre = widget.lista[index]['name'];
      });
    } */
  }

  void rewind() {
    setState(() {
      index--;
    });

    if (index < 0) {
      setState(() {
        index = widget.lista.length - 1;
      });
    }

    print(index);

    widget.player.pause();
    var x = true;
    if (x = true) {
      assets.open(
          Audio.network(
              "https://musiclyapi.herokuapp.com/music/${widget.lista[index]['ruta']}",
              metas: Metas(
                  title: widget.lista[index]['name'],
                  artist: widget.lista[index]['autor'],
                  album: widget.lista[index]['album'])),
          showNotification: true,
          audioFocusStrategy: AudioFocusStrategy.request(
              resumeAfterInterruption: true,
              resumeOthersPlayersAfterDone: true),
          notificationSettings: NotificationSettings(
            customNextAction: (player) => {forward()},
            customPrevAction: (player) => {rewind()},
            seekBarEnabled: true,
          ));

      /* var play = widget.player.setUrl(
            'https://musiclyapi.herokuapp.com/music/${widget.lista[index]['ruta']}');
        widget.player.play();
        AudioManager.instance
            .start(
                "https://musiclyapi.herokuapp.com/music/${widget.lista[index]['ruta']}",
                // "network format resource"
                // "local resource (file://${file.path})"
                "${widget.lista[index]['name']}",
                desc: "desc",
                // cover: "network cover image resource"
                cover: "assets/icon/icon.png")
            .then((err) {
          print(err);
        }); */

      setState(() {
        nombre = widget.lista[index]['name'];
      });
    }
  }

/*   @override
 /*  void dispose() {
    // 释放所有资源
    AudioManager.instance.stop();
    super.dispose();
  } */ */
}

class ModalPlaylist extends StatelessWidget {
  final music;
  const ModalPlaylist({Key key, this.music}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text("${this.music}")),
      ),
      Divider(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text("Playlist")),
      ),
      Divider(),
      Playlist(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
            color: Colors.green, onPressed: () {}, child: Text("New Playlist")),
      )
    ]));
  }
}

class Playlist extends StatelessWidget {
  const Playlist({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      child: ListView(scrollDirection: Axis.horizontal, children: [
        Row(
          children: [playlist(), playlist(), playlist()],
        )
      ]),
    );
  }
}
