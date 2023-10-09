// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class KPlayerScreen extends StatefulWidget {
//   final String videoUrl;
//   final String videoTitle;
//   const KPlayerScreen(
//       {super.key, required this.videoUrl, required this.videoTitle});

//   @override
//   State<KPlayerScreen> createState() => _KPlayerScreenState();
// }

// class _KPlayerScreenState extends State<KPlayerScreen> {
//   VideoPlayerController? videoPlayerController;
//   ChewieController? chewieController;
//   @override
//   void initState() {
//     super.initState();
//     videoPlayerController =
//         VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
//     // ..initialize().then((value) => setState(() {}));

//     chewieController = ChewieController(
//       // allowFullScreen: false,
//       allowedScreenSleep: false,
//       autoInitialize: true,
//       showControls: true,
//       showOptions: true,

//       videoPlayerController: videoPlayerController!,
//       fullScreenByDefault: true,
//       autoPlay: true,
//       looping: false,
//     );

//     Future.delayed(const Duration(seconds: 0))
//         .then((_) => chewieController!.enterFullScreen());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Theme.of(context).primaryColorDark,
//         appBar: AppBar(
//             backgroundColor: Theme.of(context).primaryColorDark,
//             title: Text(
//               widget.videoTitle,
//               // style: TextStyle(color: Colors.white),
//             )),
//         body: Center(
//             child:

//                 //  !(videoPlayerController!.value.isInitialized)
//                 //     ? const CircularProgressIndicator()
//                 //     :
//                 Chewie(
//           controller: chewieController!,
//         )));
//   }

//   @override
//   void dispose() {
//     chewieController?.dispose();
//     videoPlayerController?.dispose();
//     super.dispose();
//   }
// }
