import 'package:flutter/material.dart';
import 'package:testplayer/appinio_player.dart';
import 'package:testplayer/flick_player.dart';
import 'package:testplayer/player_screen.dart';
import 'package:testplayer/video_player.dart';

class ButtonScreen extends StatefulWidget {
  const ButtonScreen({super.key});

  @override
  State<ButtonScreen> createState() => _ButtonScreenState();
}

class _ButtonScreenState extends State<ButtonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const

                          // KPlayerScreen(
                          //       videoUrl:
                          //           "https://vz-eadc8eb2-d21.b-cdn.net/74fb1cdb-f41a-43cb-9897-490f440f5a1b/playlist.m3u8",
                          //       videoTitle: 'kk',
                          //     )
                          // AppinioPlayer(
                          //   videoUrl:
                          //       "https://vz-eadc8eb2-d21.b-cdn.net/74fb1cdb-f41a-43cb-9897-490f440f5a1b/playlist.m3u8",
                          //   videoTitle: 'kk',
                          // )
                          // FlickPlayerScreen(
                          //   videoUrl:
                          //       "https://vz-eadc8eb2-d21.b-cdn.net/74fb1cdb-f41a-43cb-9897-490f440f5a1b/playlist.m3u8",
                          //   videoTitle: 'kk',
                          // )
                          VideoPlayerScreen(
                            videoUrl:
                                "https://vz-eadc8eb2-d21.b-cdn.net/74fb1cdb-f41a-43cb-9897-490f440f5a1b/playlist.m3u8",
                            videoTitle: 'kk',
                          )));
            },
            child: const Text("Play")),
      ),
    );
  }
}
