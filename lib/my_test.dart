// //THIS PLAYER IS FOR ANDROID ONLY
// import 'dart:async';
// import 'dart:developer';

// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:phando_latest/constants/color_constant.dart';
// import 'package:phando_latest/constants/text_constant.dart';
// import 'package:phando_latest/presentation/pages/video_player_page/presentation/video_player_shimmer.dart';
// import 'package:phando_latest/presentation/widget/common_widget.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:vibration/vibration.dart';
// import 'package:video_player/video_player.dart';

// import '../../../../constants/image_url_const.dart';
// import '../../watchlist_module/data/repositories/watchlist_repo.dart';
// import '../data/models/video_player_model.dart';
// import 'flexi_player.dart';
// import 'video_player_widgets.dart';

// class OnlyPlayer extends StatefulWidget {
//   final String videoId;
//   final VideoPlayerModel screenDataRaw;

//   const OnlyPlayer(
//       {Key? key, required this.videoId, required this.screenDataRaw})
//       : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return _OnlyPlayerState();
//   }
// }

// class _OnlyPlayerState extends State<OnlyPlayer> {
//   VideoPlayerController? _videoPlayerController1;
//   ChewieController? _chewieController;
//   int? bufferDelay;
//   bool _showPlayButton = true;
//   int _videoDuration = 0;
//   int _videoPosition = 0;
//   Timer? _timer;
//   String? uToken;
//   VideoPlayerModel? screenData;
//   bool isLive = false;
//   late bool watchList;
//   bool isLoading = true;
//   final _razorpay = Razorpay();

//   @override
//   void initState() {
//     super.initState();
//     fetchUserToken();
//     fetchData(widget.screenDataRaw);
//     watchList = widget.screenDataRaw.data?.isWishlist == 1 ? true : false;
//   }

//   fetchUserToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       uToken = prefs.getString('userToken');
//     });
//   }

//   fetchData(VideoPlayerModel screenDataRaw) async {
//     setState(() {
//       screenData = screenDataRaw;

//       if (screenData?.data?.isLive == 1) {
//         isLive = true;
//       }
//       if (screenData?.data?.isWishlist == 1 ? true : false) {
//         watchList = true;
//       }
//       isLoading = false;
//     });

//     if (mounted) {
//       screenData!.status == "success" ? initializePlayer() : emptyFn();
//     }
//     screenData!.status == "success"
//         ? null
//         : Fluttertoast.showToast(msg: thisIsPremiumContent);
//     // });
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (mounted) {
//         setState(() {
//           _videoPosition = _videoPlayerController1!.value.position.inSeconds;
//         });
//       }
//     });
//   }

//   void _stopTimer() {
//     _timer?.cancel();
//   }

//   emptyFn() {}

//   Future<void> initializePlayer() async {
//     _videoPlayerController1 = VideoPlayerController.network(
//         (screenData!.data?.mediaUrl == null || screenData?.data?.mediaUrl == "")
//             ? screenData!.data!.trailers!.isNotEmpty
//                 ? screenData!.data!.trailers![0].mediaUrl!
//                 : ""
//             : screenData!.data!.mediaUrl!);
//     log("VIDEO URL ${screenData!.data?.mediaUrl}");

//     if (_videoPlayerController1?.dataSource == null ||
//         _videoPlayerController1?.dataSource == "") {
//       customSnackbar(context, noVideoLink);
//     } else {
//       if (_videoPlayerController1!.dataSource.contains("m3u8")) {
//         await Future.wait([
//           _videoPlayerController1!.initialize(),
//         ]);
//         _createChewieController();
//         if (mounted) {
//           setState(() {});
//         }
//         _videoPlayerController1!.addListener(() async {
//           if (_videoPlayerController1!.value.isPlaying) {
//             if (mounted) {
//               await Future.delayed(const Duration(seconds: 3)).then((value) {
//                 setState(() {
//                   _showPlayButton = false;
//                 });
//               });
//             }
//             _startTimer();
//           } else {
//             if (mounted) {
//               setState(() {
//                 _showPlayButton = true;
//               });
//             }

//             _stopTimer();
//           }

//           if (mounted) {
//             setState(() {
//               _videoDuration =
//                   _videoPlayerController1!.value.duration.inSeconds;
//               _videoPosition =
//                   _videoPlayerController1!.value.position.inSeconds;
//             });
//           }
//         });
//       } else {
//         customSnackbar(context, invalidUrl);
//       }
//     }
//   }

//   void _createChewieController() {
//     _chewieController = ChewieController(
//       autoInitialize: true,
//       aspectRatio: 16 / 9,
//       showControlsOnInitialize: false,
//       showOptions: false,
//       showControls: true,
//       allowFullScreen: true,
//       videoPlayerController: _videoPlayerController1!,
//       autoPlay: true,
//       looping: false,
//       progressIndicatorDelay:
//           bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,

//       // additionalOptions: (context) {
//       //   return <OptionItem>[
//       //     OptionItem(
//       //       onTap: toggleVideo,
//       //       iconData: Icons.live_tv_sharp,
//       //       title: 'Toggle Video Src',
//       //     ),
//       //   ];
//       // },

//       hideControlsTimer: const Duration(seconds: 3),

//       // Try playing around with some of these other options:

//       materialProgressColors: ChewieProgressColors(
//         playedColor: Colors.red,
//         handleColor: Colors.white,
//         backgroundColor: Colors.grey[200]!,
//         bufferedColor: Colors.grey[300]!,
//       ),
//       placeholder: Container(
//         color: Colors.black,
//       ),
//       // allowPlaybackSpeedChanging: true

//       // autoInitialize: true,
//     );
//   }

//   int currPlayIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     double sWidth = MediaQuery.of(context).size.width;
//     double sHeight = MediaQuery.of(context).size.height;
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.of(context)
//             .pushNamedAndRemoveUntil('/homeScreen', (route) => false);
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: bgColor,
//         body: isLoading
//             ? SingleChildScrollView(child: videoLoaderShimmer(sHeight, sWidth))
//             : SafeArea(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       _chewieController != null &&
//                               _chewieController!
//                                   .videoPlayerController.value.isInitialized
//                           ? AspectRatio(
//                               aspectRatio: 16 / 9,
//                               child: Stack(
//                                 children: [
//                                   Chewie(controller: _chewieController!),
//                                   Positioned.fill(
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         //======
//                                         setState(() {
//                                           _showPlayButton = !_showPlayButton;
//                                         });
//                                         //======

//                                         // setState(() {

//                                         //   if (_videoPlayerController1!
//                                         //       .value.isPlaying) {
//                                         //     _chewieController!.pause();
//                                         //   } else {
//                                         //     _chewieController!.play();
//                                         //   }
//                                         // });
//                                       },
//                                       child: Stack(
//                                         children: [
//                                           AnimatedOpacity(
//                                             duration: const Duration(
//                                                 milliseconds: 300),
//                                             opacity:
//                                                 _showPlayButton ? 1.0 : 0.0,
//                                             child: Container(
//                                               color:
//                                                   Colors.black.withOpacity(0.5),
//                                               child: Center(
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceAround,
//                                                   children: [
//                                                     IconButton(
//                                                       icon: const Icon(
//                                                         Icons.replay_10,
//                                                         size: 30,
//                                                         color: Colors.white,
//                                                       ),
//                                                       onPressed: () {
//                                                         _videoPlayerController1!
//                                                             .seekTo(Duration(
//                                                                 seconds: _videoPlayerController1!
//                                                                         .value
//                                                                         .position
//                                                                         .inSeconds -
//                                                                     10));
//                                                         customSnackbar(
//                                                             context, backward);
//                                                       },
//                                                     ),
//                                                     GestureDetector(
//                                                       onTap: () {
//                                                         setState(() {
//                                                           if (_videoPlayerController1!
//                                                               .value
//                                                               .isPlaying) {
//                                                             _chewieController!
//                                                                 .pause();
//                                                           } else {
//                                                             _chewieController!
//                                                                 .play();
//                                                           }
//                                                         });
//                                                       },
//                                                       child:
//                                                           _videoPlayerController1!
//                                                                   .value
//                                                                   .isPlaying
//                                                               ? const Icon(
//                                                                   Icons.pause,
//                                                                   color: Colors
//                                                                       .white,
//                                                                   size: 50.0,
//                                                                 )
//                                                               : const Icon(
//                                                                   Icons
//                                                                       .play_arrow,
//                                                                   color: Colors
//                                                                       .white,
//                                                                   size: 50.0,
//                                                                 ),
//                                                     ),
//                                                     IconButton(
//                                                       icon: const Icon(
//                                                         Icons.forward_10,
//                                                         size: 30,
//                                                         color: Colors.white,
//                                                       ),
//                                                       onPressed: () {
//                                                         _videoPlayerController1!
//                                                             .seekTo(Duration(
//                                                                 seconds: _videoPlayerController1!
//                                                                         .value
//                                                                         .position
//                                                                         .inSeconds +
//                                                                     10));
//                                                         customSnackbar(
//                                                             context, forward);
//                                                       },
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Align(
//                                             alignment: Alignment.bottomCenter,
//                                             child: AnimatedOpacity(
//                                               duration: const Duration(
//                                                   milliseconds: 300),
//                                               opacity:
//                                                   _showPlayButton ? 1.0 : 0.0,
//                                               child: Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     bottom: 5.0),
//                                                 child: Row(
//                                                   mainAxisAlignment: isLive
//                                                       ? MainAxisAlignment.end
//                                                       : MainAxisAlignment
//                                                           .center,
//                                                   children: [
//                                                     isLive
//                                                         ? Row(
//                                                             children: [
//                                                               const Icon(
//                                                                   Icons.circle,
//                                                                   color: Colors
//                                                                       .red,
//                                                                   size: 10),
//                                                               myText(
//                                                                   live,
//                                                                   Colors.white,
//                                                                   15)
//                                                             ],
//                                                           )
//                                                         : Row(
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .center,
//                                                             children: [
//                                                               Text(
//                                                                 "${_videoPosition ~/ 60}:${_videoPosition % 60}",
//                                                                 style: const TextStyle(
//                                                                     color: Colors
//                                                                         .white,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold),
//                                                               ),
//                                                               hSpacer(5),
//                                                               SizedBox(
//                                                                 width: sWidth -
//                                                                     130,
//                                                                 child:
//                                                                     VideoProgressIndicator(
//                                                                   _videoPlayerController1!,
//                                                                   allowScrubbing:
//                                                                       true,
//                                                                   colors:
//                                                                       VideoProgressColors(
//                                                                     playedColor:
//                                                                         Colors
//                                                                             .red,
//                                                                     bufferedColor:
//                                                                         Colors
//                                                                             .white,
//                                                                     backgroundColor: Colors
//                                                                         .grey
//                                                                         .withOpacity(
//                                                                             0.2),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               hSpacer(5),
//                                                               Text(
//                                                                 "${_videoDuration ~/ 60}:${_videoDuration % 60}",
//                                                                 style: const TextStyle(
//                                                                     color: Colors
//                                                                         .white,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                     GestureDetector(
//                                                       onTap: () {
//                                                         _chewieController
//                                                             ?.enterFullScreen();
//                                                       },
//                                                       child: const Icon(
//                                                         Icons.fullscreen,
//                                                         color: Colors.white,
//                                                         size: 30,
//                                                       ),
//                                                     ),
//                                                     // const Icon(
//                                                     //   Icons.settings,
//                                                     //   color: Colors.white,
//                                                     // )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           AnimatedOpacity(
//                                             duration: const Duration(
//                                                 milliseconds: 300),
//                                             opacity:
//                                                 _showPlayButton ? 1.0 : 0.0,
//                                             child: GestureDetector(
//                                               onTap: () {
//                                                 Navigator.of(context)
//                                                     .pushNamedAndRemoveUntil(
//                                                         '/homeScreen',
//                                                         (route) => false);
//                                               },
//                                               child: const Padding(
//                                                 padding: EdgeInsets.all(15.0),
//                                                 child: Icon(
//                                                   Icons.arrow_back_ios,
//                                                   color: Colors.red,
//                                                   size: 20,
//                                                 ),
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           : AspectRatio(
//                               aspectRatio: 16 / 9,
//                               child: Stack(
//                                 children: [
//                                   Image.network(screenData!.data?.thumbnail ??
//                                       noImageAvailable),
//                                   IconButton(
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                       },
//                                       icon: const Icon(
//                                         Icons.arrow_back_ios,
//                                         color: Colors.white,
//                                       ))
//                                 ],
//                               )),
//                       Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             screenData!.mediaCode == "rent_or_buy"
//                                 ? Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: GestureDetector(
//                                               onTap: () async {
//                                                 print("asdfadafas");
//                                                 // var options = {
//                                                 //   'key': useStaticTestKey
//                                                 //       ? 'rzp_test_BWqfBmcCYhpsci'
//                                                 //       : value!.key,
//                                                 //   // 'key': value!.key,
//                                                 //   'amount': screenData!
//                                                 //           .purchaseOption![1]
//                                                 //           .finalPrice! *
//                                                 //       100,
//                                                 //   'name':
//                                                 //       value!.orderDetails!.name,
//                                                 //   // 'description':
//                                                 //   //     value.description,
//                                                 //   'prefill': {
//                                                 //     'contact': value.userMobile,
//                                                 //     'email': value.userEmail
//                                                 //   }
//                                                 // };
//                                                 // try {
//                                                 //   _razorpay.open(options);
//                                                 //   // setState(() {
//                                                 //   //   isLoading = false;
//                                                 //   // });
//                                                 // } catch (e) {
//                                                 //   customSnackbar(
//                                                 //       context, e.toString());
//                                                 //   Fluttertoast.showToast(
//                                                 //       msg: e.toString());
//                                                 //   setState(() {
//                                                 //     isLoading = false;
//                                                 //   });
//                                                 // }
//                                               },
//                                               child: Container(
//                                                 height: sHeight * 0.05,
//                                                 decoration: BoxDecoration(
//                                                     color: Colors.blue,
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             5)),
//                                                 child: Center(
//                                                     child: myText(
//                                                         "$buyAt ${screenData!.purchaseOption![1].currencySymbol} ${screenData!.purchaseOption![1].finalPrice}/-",
//                                                         Colors.white,
//                                                         15)),
//                                               ),
//                                             ),
//                                           ),
//                                           hSpacer(sWidth * 0.04),
//                                           Expanded(
//                                             child: Container(
//                                               height: sHeight * 0.05,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.blue,
//                                                   borderRadius:
//                                                       BorderRadius.circular(5)),
//                                               child: Center(
//                                                   child: myText(
//                                                       "$rentAt ${screenData!.purchaseOption![0].currencySymbol} ${screenData!.purchaseOption![0].finalPrice}/-",
//                                                       Colors.white,
//                                                       15)),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       vSpacer(sHeight * 0.03)
//                                     ],
//                                   )
//                                 : Container(),
//                             screenData!.mediaCode == "only_buy"
//                                 ? Column(
//                                     children: [
//                                       vSpacer(sHeight * 0.01),
//                                       Container(
//                                         height: sHeight * 0.05,
//                                         decoration: BoxDecoration(
//                                             color: Colors.blue,
//                                             borderRadius:
//                                                 BorderRadius.circular(5)),
//                                         child: Center(
//                                             child: myText(
//                                                 "$buyAt ${screenData!.purchaseOption![0].currencySymbol} ${screenData!.purchaseOption![0].finalPrice}/-",
//                                                 Colors.white,
//                                                 15)),
//                                       ),
//                                       vSpacer(sHeight * 0.02)
//                                     ],
//                                   )
//                                 : Container(),
//                             Visibility(
//                               visible: screenData!.status == "success"
//                                   ? false
//                                   : true,
//                               child: Column(
//                                 children: [
//                                   vSpacer(sHeight * 0.008),
//                                   sphericalRedButton(subscribe, context),
//                                   vSpacer(sHeight * 0.008),
//                                 ],
//                               ),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Flexible(
//                                     child: videoHeader(
//                                         screenData!.data?.title ?? "")),
//                                 //WISHLIST COMMENTED
//                                 GestureDetector(
//                                   onTap: () {
//                                     WatchlistApi()
//                                         .modifyWishlist(
//                                             screenData!.data!.id.toString(),
//                                             "M",
//                                             watchList == true ? "0" : "1",
//                                             uToken!)
//                                         .then((value) {
//                                       Vibration.vibrate(duration: 100);
//                                       if (value!.status == "success") {
//                                         setState(() {
//                                           watchList = !watchList;
//                                         });
//                                       }
//                                     });
//                                   },
//                                   child: watchList == false
//                                       ? watchListRow(Icons.add, addWatchList)
//                                       : watchListRow(
//                                           Icons.check, addedWatchList),
//                                 ),
//                                 //WISHLIST COMMENTED
//                               ],
//                             ),
//                             vSpacer(15),
//                             Visibility(
//                               visible: screenData?.data?.detail! == ""
//                                   ? false
//                                   : true,
//                               child: myText(
//                                   screenData!.data?.detail!, Colors.white, 12),
//                             ),
//                             infoBar(sHeight, screenData),
//                             Visibility(
//                               visible: screenData!.data?.trailers?.isNotEmpty ??
//                                   false,
//                               child: Column(children: [
//                                 vSpacer(20),
//                                 trailersNextras(),
//                                 vSpacer(10),
//                                 trailerTile(
//                                     sHeight,
//                                     sWidth,
//                                     screenData!.data?.trailers as List<Trailer>,
//                                     _videoPlayerController1,
//                                     _chewieController,
//                                     widget.videoId)
//                               ]),
//                             ),
//                             Visibility(
//                               visible:
//                                   screenData!.data?.creditList?.isNotEmpty ??
//                                       false,
//                               child: Column(
//                                 children: [
//                                   vSpacer(10),
//                                   castNcrew(),
//                                   castNCrew(sHeight, sWidth, screenData),
//                                 ],
//                               ),
//                             ),
//                             moreLike(),
//                             releatedTile(
//                                 sHeight,
//                                 sWidth,
//                                 screenData!.data!.related as List<Related>,
//                                 _videoPlayerController1,
//                                 _chewieController),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _videoPlayerController1?.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }
// }