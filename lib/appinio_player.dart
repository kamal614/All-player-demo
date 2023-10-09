import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class AppinioPlayer extends StatefulWidget {
  final String videoUrl;
  final String videoTitle;
  const AppinioPlayer(
      {super.key, required this.videoUrl, required this.videoTitle});

  @override
  State<AppinioPlayer> createState() => _AppinioPlayerState();
}

class _AppinioPlayerState extends State<AppinioPlayer> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  // String videoUrl =
  //     "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then((value) => setState(() {}));

    _customVideoPlayerController = CustomVideoPlayerController(
      customVideoPlayerSettings: const CustomVideoPlayerSettings(
          alwaysShowThumbnailOnVideoPaused: true,
          autoFadeOutControls: true,
          controlBarAvailable: true,
          // playButton: Icon(Icons.play_arrow),
          // showPlayButton: true,
          customAspectRatio: 16 / 9,
          enterFullscreenOnStart: true),
      context: context,
      videoPlayerController: videoPlayerController,
    );

    // Future.delayed(const Duration(seconds: 0))
    //     .then((_) => _customVideoPlayerController.setFullscreen(true));
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            // _customVideoPlayerController.isNull
            //     ? const Center(
            //         child: CircularProgressIndicator(
            //         color: Colors.black,
            //       ))
            //     :
            CustomVideoPlayer(
                customVideoPlayerController: _customVideoPlayerController),
      ),
    );
  }
}
