import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'test_video_player_screen.dart';

class TestButtonScreen extends StatefulWidget {
  const TestButtonScreen({super.key});

  @override
  State<TestButtonScreen> createState() => _TestButtonScreenState();
}

late VideoPlayerController controllerTest;

class _TestButtonScreenState extends State<TestButtonScreen> {
  @override
  void initState() {
    log("CALLING INIT");
    super.initState();
    controllerTest = VideoPlayerController.networkUrl(Uri.parse(
        'https://vz-eadc8eb2-d21.b-cdn.net/74fb1cdb-f41a-43cb-9897-490f440f5a1b/playlist.m3u8'))
      ..initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TestVideoPlayerScreen(
                            videoUrl:
                                "https://vz-eadc8eb2-d21.b-cdn.net/74fb1cdb-f41a-43cb-9897-490f440f5a1b/playlist.m3u8",
                            videoTitle: 'kk',
                          )));
            },
            child: const Text("Test Play")),
      ),
    );
  }

  @override
  void dispose() {
    controllerTest.dispose();
    super.dispose();
  }
}
