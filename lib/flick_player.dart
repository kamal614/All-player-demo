import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class FlickPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String videoTitle;
  const FlickPlayerScreen(
      {super.key, required this.videoUrl, required this.videoTitle});

  @override
  State<FlickPlayerScreen> createState() => _FlickPlayerScreenState();
}

class _FlickPlayerScreenState extends State<FlickPlayerScreen> {
  FlickManager? flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      autoInitialize: true,
      autoPlay: true,
      videoPlayerController:
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl)),
    );

    Future.delayed(const Duration(seconds: 0))
        .then((value) => flickManager!.flickControlManager!.enterFullscreen());

    Future.delayed(const Duration(seconds: 1)).then((value) {
      flickManager?.flickControlManager?.addListener(() {
        if (!flickManager!.flickControlManager!.isFullscreen) {
          Navigator.pop(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlickVideoPlayer(
        wakelockEnabledFullscreen: true,
        wakelockEnabled: true,
        preferredDeviceOrientation: const [
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft
        ],
        systemUIOverlay: [],
        flickManager: flickManager!,
      ),
    );
  }

  @override
  void dispose() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.bottom]);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    flickManager!.dispose();
    super.dispose();
  }
}
