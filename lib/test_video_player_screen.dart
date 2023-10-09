import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testplayer/test_button_screen.dart';
import 'package:video_player/video_player.dart';

class TestVideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String videoTitle;
  const TestVideoPlayerScreen(
      {super.key, required this.videoUrl, required this.videoTitle});

  @override
  State<TestVideoPlayerScreen> createState() => _TestVideoPlayerScreenState();
}

class _TestVideoPlayerScreenState extends State<TestVideoPlayerScreen> {
  // late VideoPlayerController _controller;
  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
    //   ..initialize().then((_) {
    //     setState(() {});
    //     _controller.play();
    //   });

    controllerTest.play();

    controllerTest.addListener(() {
      setState(() {
        _currentPosition = controllerTest.value.position;
      });
    });

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
  }

  bool _showPlayButton = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Center(
        child: controllerTest.value.isInitialized
            ? Stack(
                children: [
                  VideoPlayer(controllerTest),
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showPlayButton = !_showPlayButton;
                        });
                      },
                      child: Stack(
                        children: [
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: _showPlayButton ? 1.0 : 0.0,
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.replay_10,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        controllerTest.seekTo(Duration(
                                            seconds: controllerTest
                                                    .value.position.inSeconds -
                                                10));
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (controllerTest.value.isPlaying) {
                                            controllerTest.pause();
                                          } else {
                                            controllerTest.play();
                                          }
                                        });
                                      },
                                      child: controllerTest.value.isPlaying
                                          ? const Icon(
                                              Icons.pause,
                                              color: Colors.white,
                                              size: 50.0,
                                            )
                                          : const Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                              size: 50.0,
                                            ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.forward_10,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        controllerTest.seekTo(Duration(
                                            seconds: controllerTest
                                                    .value.position.inSeconds +
                                                10));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: _showPlayButton ? 1.0 : 0.0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _showPlayButton ? 1.0 : 0.0,
                        child: VideoProgressIndicator(controllerTest,
                            allowScrubbing: true),
                      ),
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    // controllerTest.dispose();
    controllerTest.pause();
    super.dispose();
  }
}
