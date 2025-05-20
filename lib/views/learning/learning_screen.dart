// import 'dart:async';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:vedalaya_app/core/themes/app_constants.dart';
// import 'package:vedalaya_app/view/learning/modules/chapter_selection.dart';
// import 'package:vedalaya_app/view/learning/modules/language_selection.dart';
// import 'package:video_player/video_player.dart';

// class LearningScreen extends StatefulWidget {
//   const LearningScreen({super.key});

//   @override
//   State<LearningScreen> createState() => _LearningScreenState();
// }

// class _LearningScreenState extends State<LearningScreen> {
//   bool isPause = true;
//   bool isMusic = true;
//   late VideoPlayerController _videoController;
//   final AudioPlayer _audioPlayer = AudioPlayer();

//   bool _showForwardIcon = false;
//   bool _showBackwardIcon = false;
//   bool _isFullScreen = false;
//   bool _showControls = true;

//   Duration _audioDuration = Duration.zero;
//   Duration _audioPosition = Duration.zero;

//   double _playbackSpeed = 1.0;
//   Timer? _hideControlsTimer;

//   String uri =
//       'https://stream.mux.com/wlfOVYuv7OLpHOp17Hz75Kx00Vx6UeMf002k7uae01oo5k.m3u8';

//   @override
//   void initState() {
//     super.initState();

//     final uri =
//         'https://stream.mux.com/wlfOVYuv7OLpHOp17Hz75Kx00Vx6UeMf002k7uae01oo5k.m3u8';
//     _videoController = VideoPlayerController.networkUrl(Uri.parse(uri))
//       ..initialize().then((_) {
//         setState(() {});
//       });
//     _videoController.addListener(() {
//       if (mounted) setState(() {});
//     });

//     _audioPlayer.onDurationChanged.listen((duration) {
//       setState(() {
//         _audioDuration = duration;
//       });
//     });

//     _audioPlayer.onPositionChanged.listen((position) {
//       setState(() {
//         _audioPosition = position;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _videoController.dispose();
//     _audioPlayer.dispose();
//     _hideControlsTimer?.cancel();
//     super.dispose();
//   }

//   void _toggleFullScreen() {
//     setState(() {
//       _isFullScreen = !_isFullScreen;
//     });
//   }

//   void _startHideControlsTimer() {
//     _hideControlsTimer?.cancel();
//     _hideControlsTimer = Timer(const Duration(seconds: 2), () {
//       if (mounted && !isPause) {
//         setState(() {
//           _showControls = false;
//         });
//       }
//     });
//   }

//   void _togglePlayPause() async {
//     setState(() {
//       isPause = !isPause;
//     });

//     if (isMusic) {
//       if (isPause) {
//         await _audioPlayer.pause();
//         _hideControlsTimer?.cancel();
//       } else {
//         final uri =
//             'https://stream.mux.com/wlfOVYuv7OLpHOp17Hz75Kx00Vx6UeMf002k7uae01oo5k.m3u8';
//         await _audioPlayer.setSourceUrl(uri);
//         _audioPlayer.setPlaybackRate(_playbackSpeed);
//         _startHideControlsTimer();
//       }
//     } else {
//       if (!isPause) {
//         _videoController.setPlaybackSpeed(_playbackSpeed);
//         _videoController.play();
//         _startHideControlsTimer();
//       } else {
//         _videoController.pause();
//         _hideControlsTimer?.cancel();
//       }
//     }

//     // Always show controls when play/pause is toggled
//     setState(() {
//       _showControls = true;
//     });
//   }

//   void _toggleMode() async {
//     final currentPosition =
//         isMusic ? _audioPosition : _videoController.value.position;
//     final wasPaused = isPause;

//     setState(() {
//       isMusic = !isMusic;
//     });

//     if (isMusic) {
//       await _videoController.pause();
//       await _audioPlayer.seek(currentPosition);
//       await _audioPlayer.setPlaybackRate(_playbackSpeed);

//       if (!wasPaused) {
//         final uri =
//             'https://stream.mux.com/wlfOVYuv7OLpHOp17Hz75Kx00Vx6UeMf002k7uae01oo5k.m3u8';
//         // await _audioPlayer.play(AssetSource('icons/hanuman.mp4'));
//         await _audioPlayer.setSourceUrl(uri);
//         _startHideControlsTimer();
//       }
//     } else {
//       await _audioPlayer.pause();
//       await _videoController.seekTo(currentPosition);
//       await _videoController.setPlaybackSpeed(_playbackSpeed);

//       if (!wasPaused) {
//         _videoController.play();
//         _startHideControlsTimer();
//       }
//     }

//     // Show controls when mode is toggled
//     setState(() {
//       _showControls = true;
//     });
//   }

//   void _backward() {
//     if (isMusic) {
//       final newPosition = _audioPosition - const Duration(seconds: 2);
//       _audioPlayer
//           .seek(newPosition > Duration.zero ? newPosition : Duration.zero);
//     } else {
//       final currentPosition = _videoController.value.position;
//       Duration newPosition = currentPosition - const Duration(seconds: 2);
//       if (newPosition < Duration.zero) newPosition = Duration.zero;
//       _videoController.seekTo(newPosition);
//     }

//     setState(() => _showBackwardIcon = true);
//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (mounted) setState(() => _showBackwardIcon = false);
//     });

//     // Show controls when seeking
//     setState(() {
//       _showControls = true;
//     });
//     _startHideControlsTimer();
//   }

//   void _forward() {
//     if (isMusic) {
//       final newPosition = _audioPosition + const Duration(seconds: 2);
//       _audioPlayer
//           .seek(newPosition < _audioDuration ? newPosition : _audioDuration);
//     } else {
//       final currentPosition = _videoController.value.position;
//       final duration = _videoController.value.duration;
//       Duration newPosition = currentPosition + const Duration(seconds: 2);
//       if (newPosition > duration) newPosition = duration;
//       _videoController.seekTo(newPosition);
//     }

//     setState(() => _showForwardIcon = true);
//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (mounted) setState(() => _showForwardIcon = false);
//     });

//     // Show controls when seeking
//     setState(() {
//       _showControls = true;
//     });
//     _startHideControlsTimer();
//   }

//   void _showChapterDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return ChapterSelectionDialog(
//           currentChapterIndex: 1,
//           chapterCompletionStatus: [
//             true,
//             true,
//             false,
//             false,
//             false,
//             false,
//             false
//           ],
//           chapterNames: [
//             'Introduction',
//             'Glory of Hanuman',
//             'Chalisa Part 1',
//             'Chalisa Part 2',
//             'Chalisa Part 3',
//             'Chalisa Part 4',
//             'Chalisa Part 5',
//           ],
//         );
//       },
//     );
//   }

//   void _showSpeedSelector(BuildContext context) {
//     final speeds = [0.5, 0.7, 1.0, 1.1, 1.2, 1.5];

//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           backgroundColor: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Select Speed',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: Colors.purple,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 ...speeds.map((speed) {
//                   final isSelected = speed == _playbackSpeed;
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _playbackSpeed = speed;
//                       });

//                       if (isMusic) {
//                         _audioPlayer.setPlaybackRate(speed);
//                       } else {
//                         _videoController.setPlaybackSpeed(speed);
//                       }

//                       Navigator.of(context).pop();
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 12, horizontal: 10),
//                       margin: const EdgeInsets.symmetric(vertical: 2),
//                       decoration: BoxDecoration(
//                         color:
//                             isSelected ? Color(0xFFD6B9F3) : Colors.transparent,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         "${speed}x",
//                         style: TextStyle(
//                           color: isSelected ? Colors.purple : Colors.black,
//                           fontWeight:
//                               isSelected ? FontWeight.bold : FontWeight.normal,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//                 const SizedBox(height: 4),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildNormalScreen(BuildContext context) {
//     final screenHeight = Get.height;
//     final screenWidth = Get.width;

//     return Scaffold(
//       backgroundColor: const Color(0xFFFCF9EE),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//                 const Icon(Icons.keyboard_arrow_left, size: 30),
//                 SizedBox(width: screenWidth * 0.22),
//                 Text("Hanuman Chalisa",
//                     style: GoogleFonts.poppins(
//                       fontSize: screenWidth * 0.045,
//                       fontWeight: FontWeight.w700,
//                       color: const Color(0xFF3A0084),
//                     )),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Column(
//               children: [
//                 CustomProgressBar(progress: 4 / 9),
//                 const SizedBox(height: 4),
//                 Text("2/9 Lessons Completed",
//                     style: GoogleFonts.poppins(fontSize: screenWidth * 0.035)),
//               ],
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               height: screenHeight * 0.66,
//               width: screenWidth * 0.9,
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _showControls = !_showControls;
//                   });
//                   if (!isPause) {
//                     _startHideControlsTimer();
//                   }
//                 },
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: isMusic
//                           ? Image.asset(
//                               "assets/icons/hanuman.png",
//                               fit: BoxFit.cover,
//                               height: screenHeight * 0.66,
//                               width: screenWidth * 0.9,
//                             )
//                           : _videoController.value.isInitialized
//                               ? FittedBox(
//                                   fit: BoxFit.cover,
//                                   child: SizedBox(
//                                     height: screenHeight * 0.66,
//                                     width: screenWidth * 0.9,
//                                     child: VideoPlayer(_videoController),
//                                   ),
//                                 )
//                               : Container(
//                                   color: Colors.grey,
//                                   height: screenHeight * 0.66,
//                                   width: screenWidth * 0.9,
//                                   child: const Center(
//                                       child: CircularProgressIndicator()),
//                                 ),
//                     ),
//                     if (_showBackwardIcon)
//                       const FaIcon(FontAwesomeIcons.backward,
//                           size: 50, color: Colors.white),
//                     if (_showForwardIcon)
//                       const FaIcon(FontAwesomeIcons.forward,
//                           size: 50, color: Colors.white),
//                     if (_showControls)
//                       Positioned(
//                         top: 12,
//                         left: 10,
//                         right: 10,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             GestureDetector(
//                               onTap: () => _showChapterDialog(context),
//                               child: Container(
//                                 width: screenWidth * 0.42,
//                                 height: screenHeight * 0.03,
//                                 decoration: BoxDecoration(
//                                   color: const Color.fromRGBO(30, 30, 30, 0.5),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 alignment: Alignment.center,
//                                 child: Text("2. Glory of Hanuman",
//                                     style: GoogleFonts.poppins(
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.white,
//                                       fontSize: screenWidth * 0.035,
//                                     )),
//                               ),
//                             ),
//                             Row(
//                               children: [
//                                 GestureDetector(
//                                   onTap: () => _showSpeedSelector(context),
//                                   child:
//                                       _iconBox("assets/icons/Vector (7).svg"),
//                                 ),
//                                 const SizedBox(width: 5),
//                                 GestureDetector(
//                                   onTap: () async {
//                                     final selectedLanguage = await showDialog(
//                                       context: context,
//                                       builder: (_) => LanguageSelectionDialog(),
//                                     );
//                                     if (selectedLanguage != null) {
//                                       print(
//                                           'Selected Language: $selectedLanguage');
//                                     }
//                                   },
//                                   child: _iconBox("assets/icons/A.svg"),
//                                 ),
//                                 const SizedBox(width: 5),
//                                 GestureDetector(
//                                   onTap: _toggleMode,
//                                   child: isMusic
//                                       ? _iconBox("assets/icons/video.svg")
//                                       : _iconBox("assets/icons/music.svg"),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     if (_showControls)
//                       Positioned(
//                         top: screenHeight * 0.33,
//                         child: Row(
//                           children: [
//                             GestureDetector(
//                               onTap: _backward,
//                               child: const FaIcon(
//                                 FontAwesomeIcons.backwardStep,
//                                 color: Colors.white,
//                                 size: 30,
//                               ),
//                             ),
//                             const SizedBox(width: 50),
//                             GestureDetector(
//                               onTap: _togglePlayPause,
//                               child: FaIcon(
//                                 isPause
//                                     ? FontAwesomeIcons.play
//                                     : FontAwesomeIcons.pause,
//                                 color: Colors.white,
//                                 size: 30,
//                               ),
//                             ),
//                             const SizedBox(width: 50),
//                             GestureDetector(
//                               onTap: _forward,
//                               child: const FaIcon(
//                                 FontAwesomeIcons.forwardStep,
//                                 color: Colors.white,
//                                 size: 30,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     // if (_showControls)
//                     Positioned(
//                       bottom: 70,
//                       left: 20,
//                       right: 20,
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           "श्रीगुरु चरन सरोज रज, निज मनु मुकुर सुधारि।\nबरनऊँ रघुबर बिमल जसु, जो दायक फल चारि॥",
//                           style: GoogleFonts.poppins(
//                             color: Colors.white,
//                             fontSize: screenWidth * 0.045,
//                             height: 1.4,
//                           ),
//                           textAlign: TextAlign.start,
//                         ),
//                       ),
//                     ),
//                     // if (_showControls)
//                     Positioned(
//                       bottom: 10,
//                       left: 10,
//                       right: 10,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Slider(
//                               min: 0,
//                               max: isMusic
//                                   ? _audioDuration.inSeconds.toDouble()
//                                   : _videoController.value.duration.inSeconds
//                                       .toDouble(),
//                               value: isMusic
//                                   ? _audioPosition.inSeconds
//                                       .clamp(0, _audioDuration.inSeconds)
//                                       .toDouble()
//                                   : _videoController.value.position.inSeconds
//                                       .clamp(
//                                           0,
//                                           _videoController
//                                               .value.duration.inSeconds)
//                                       .toDouble(),
//                               onChanged: (value) {
//                                 final seekTo = Duration(seconds: value.toInt());
//                                 isMusic
//                                     ? _audioPlayer.seek(seekTo)
//                                     : _videoController.seekTo(seekTo);
//                               },
//                               activeColor: Colors.purple,
//                               inactiveColor: Colors.grey,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: _toggleFullScreen,
//                             child: const Icon(
//                               Icons.fullscreen,
//                               size: 30,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFullScreen(BuildContext context) {
//     final screenHeight = Get.height;
//     final screenWidth = Get.width;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onTap: () {
//           setState(() {
//             _showControls = !_showControls;
//           });
//           if (!isPause) {
//             _startHideControlsTimer();
//           }
//         },
//         child: Stack(
//           children: [
//             Center(
//               child: isMusic
//                   ? Image.asset(
//                       "assets/icons/hanuman.png",
//                       fit: BoxFit.cover,
//                       height: screenHeight,
//                       width: screenWidth,
//                     )
//                   : _videoController.value.isInitialized
//                       ? AspectRatio(
//                           aspectRatio: 8 / 15,
//                           child: VideoPlayer(_videoController),
//                         )
//                       : Container(
//                           color: Colors.black,
//                           child:
//                               const Center(child: CircularProgressIndicator()),
//                         ),
//             ),
//             if (_showBackwardIcon)
//               const Center(
//                 child: FaIcon(FontAwesomeIcons.backward,
//                     size: 50, color: Colors.white),
//               ),
//             if (_showForwardIcon)
//               const Center(
//                 child: FaIcon(FontAwesomeIcons.forward,
//                     size: 50, color: Colors.white),
//               ),
//             if (_showControls)
//               Positioned(
//                 top: 30,
//                 left: 10,
//                 right: 10,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () => _showChapterDialog(context),
//                       child: Container(
//                         width: screenWidth * 0.42,
//                         height: screenHeight * 0.03,
//                         decoration: BoxDecoration(
//                           color: const Color.fromRGBO(30, 30, 30, 0.5),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         alignment: Alignment.center,
//                         child: Text("2. Glory of Hanuman",
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w500,
//                               color: Colors.white,
//                               fontSize: screenWidth * 0.035,
//                             )),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () => _showSpeedSelector(context),
//                           child: _iconBox("assets/icons/Vector (7).svg"),
//                         ),
//                         const SizedBox(width: 5),
//                         GestureDetector(
//                           onTap: () async {
//                             final selectedLanguage = await showDialog(
//                               context: context,
//                               builder: (_) => LanguageSelectionDialog(),
//                             );
//                             if (selectedLanguage != null) {
//                               print('Selected Language: $selectedLanguage');
//                             }
//                           },
//                           child: _iconBox("assets/icons/A.svg"),
//                         ),
//                         const SizedBox(width: 5),
//                         GestureDetector(
//                           onTap: _toggleMode,
//                           child: isMusic
//                               ? _iconBox("assets/icons/video.svg")
//                               : _iconBox("assets/icons/music.svg"),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             if (_showControls)
//               Positioned(
//                 bottom: Get.height * 0.45,
//                 left: 0,
//                 right: 0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: _backward,
//                       child: const FaIcon(
//                         FontAwesomeIcons.backwardStep,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                     const SizedBox(width: 50),
//                     GestureDetector(
//                       onTap: _togglePlayPause,
//                       child: FaIcon(
//                         isPause
//                             ? FontAwesomeIcons.play
//                             : FontAwesomeIcons.pause,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                     const SizedBox(width: 50),
//                     GestureDetector(
//                       onTap: _forward,
//                       child: const FaIcon(
//                         FontAwesomeIcons.forwardStep,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             // if (_showControls)
//             Positioned(
//               bottom: 160,
//               left: 20,
//               right: 20,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   "श्रीगुरु चरन सरोज रज, निज मनु मुकुर सुधारि।\nबरनऊँ रघुबर बिमल जसु, जो दायक फल चारि॥",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: screenWidth * 0.045,
//                     height: 1.4,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//             // if (_showControls)
//             Positioned(
//               bottom: 40,
//               left: 20,
//               right: 20,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Slider(
//                       min: 0,
//                       max: isMusic
//                           ? _audioDuration.inSeconds.toDouble()
//                           : _videoController.value.duration.inSeconds
//                               .toDouble(),
//                       value: isMusic
//                           ? _audioPosition.inSeconds
//                               .clamp(0, _audioDuration.inSeconds)
//                               .toDouble()
//                           : _videoController.value.position.inSeconds
//                               .clamp(
//                                   0, _videoController.value.duration.inSeconds)
//                               .toDouble(),
//                       onChanged: (value) {
//                         final seekTo = Duration(seconds: value.toInt());
//                         isMusic
//                             ? _audioPlayer.seek(seekTo)
//                             : _videoController.seekTo(seekTo);
//                       },
//                       activeColor: Colors.purple,
//                       inactiveColor: Colors.grey,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: _toggleFullScreen,
//                     child: const Icon(
//                       Icons.fullscreen_exit,
//                       size: 30,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         _isFullScreen ? _buildFullScreen(context) : _buildNormalScreen(context),
//         // Show microphone icon in normal screen always, or in full screen only when controls are visible
//         if (!_isFullScreen || (_isFullScreen && _showControls))
//           Positioned(
//             left: Get.width * 0.5 - 22,
//             child: AnimatedContainer(
//               height: _isFullScreen ? Get.height * 1.58 : Get.height * 1.7,
//               duration: Duration(milliseconds: 300),
//               child: CircleAvatar(
//                 radius: 30,
//                 backgroundColor: AppConstants.purpleColor,
//                 child: const Center(
//                   child: FaIcon(
//                     FontAwesomeIcons.microphone,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _iconBox(dynamic svgPath) {
//     return Container(
//       height: Get.height * 0.030,
//       width: Get.width * 0.075,
//       padding: (svgPath == "assets/icons/Vector (7).svg")
//           ? EdgeInsets.all(Get.width * 0.017)
//           : (svgPath == "assets/icons/A.svg")
//               ? EdgeInsets.all(Get.width * 0.01)
//               : EdgeInsets.all(Get.width * 0.015),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(30, 30, 30, 0.4),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: SvgPicture.asset(
//         svgPath,
//         width: Get.width * 0.024,
//         height: Get.height * 0.016,
//       ),
//     );
//   }
// }

// class CustomProgressBar extends StatelessWidget {
//   final double progress;

//   const CustomProgressBar({super.key, required this.progress});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: Get.width * 0.7,
//       height: Get.height * 0.012,
//       decoration: BoxDecoration(
//         color: const Color(0xFFE5E5E5),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Stack(
//         children: [
//           FractionallySizedBox(
//             alignment: Alignment.centerLeft,
//             widthFactor: progress.clamp(0.0, 1.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: const Color.fromRGBO(27, 161, 67, 1),
//                 borderRadius: BorderRadius.circular(14),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:vedalaya_app/core/themes/app_constants.dart';
// import 'package:vedalaya_app/view/learning/modules/chapter_selection.dart';
// import 'package:vedalaya_app/view/learning/modules/custom_progressbar.dart';
// import 'package:vedalaya_app/view/learning/modules/language_selection.dart';
// import 'package:video_player/video_player.dart';
// // import "package:subti"

// class LearningScreen extends StatefulWidget {
//   const LearningScreen({super.key});

//   @override
//   State<LearningScreen> createState() => _LearningScreenState();
// }

// class _LearningScreenState extends State<LearningScreen> {
//   bool isPause = true;
//   bool isMusic = true;
//   late VideoPlayerController _videoController;

//   bool _showForwardIcon = false;
//   bool _showBackwardIcon = false;
//   bool _isFullScreen = false;
//   bool _showControls = true;

//   double _playbackSpeed = 1.0;
//   Timer? _hideControlsTimer;

//   final String videoUrl =
//       'https://stream.mux.com/wlfOVYuv7OLpHOp17Hz75Kx00Vx6UeMf002k7uae01oo5k.m3u8';

//   @override
//   void initState() {
//     super.initState();

//     _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
//       ..initialize().then((_) {
//         setState(() {});
//         if (!isPause) _videoController.play();
//       });

//     _videoController.addListener(() {
//       if (mounted) setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _videoController.dispose();
//     _hideControlsTimer?.cancel();
//     super.dispose();
//   }

//   void _toggleFullScreen() {
//     setState(() {
//       _isFullScreen = !_isFullScreen;
//     });
//   }

//   void _startHideControlsTimer() {
//     _hideControlsTimer?.cancel();
//     _hideControlsTimer = Timer(const Duration(seconds: 2), () {
//       if (mounted && !isPause) {
//         setState(() {
//           _showControls = false;
//         });
//       }
//     });
//   }

//   Future<void> _togglePlayPause() async {
//     setState(() {
//       isPause = !isPause;
//     });

//     if (!isPause) {
//       await _videoController.play();
//       _startHideControlsTimer();
//     } else {
//       await _videoController.pause();
//       _hideControlsTimer?.cancel();
//     }

//     setState(() {
//       _showControls = true;
//     });
//   }

//   void _toggleMode() {
//     setState(() {
//       isMusic = !isMusic;
//       _showControls = true;
//     });
//     if (!isPause) {
//       _startHideControlsTimer();
//     }
//   }

//   void _backward() {
//     final currentPosition = _videoController.value.position;
//     Duration newPosition = currentPosition - const Duration(seconds: 2);
//     if (newPosition < Duration.zero) newPosition = Duration.zero;
//     _videoController.seekTo(newPosition);

//     setState(() => _showBackwardIcon = true);
//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (mounted) setState(() => _showBackwardIcon = false);
//     });

//     setState(() {
//       _showControls = true;
//     });
//     _startHideControlsTimer();
//   }

//   void _forward() {
//     final currentPosition = _videoController.value.position;
//     final duration = _videoController.value.duration;
//     Duration newPosition = currentPosition + const Duration(seconds: 2);
//     if (newPosition > duration) newPosition = duration;
//     _videoController.seekTo(newPosition);

//     setState(() => _showForwardIcon = true);
//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (mounted) setState(() => _showForwardIcon = false);
//     });

//     setState(() {
//       _showControls = true;
//     });
//     _startHideControlsTimer();
//   }

//   void _showChapterDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return ChapterSelectionDialog(
//           currentChapterIndex: 1,
//           chapterCompletionStatus: [
//             true,
//             true,
//             false,
//             false,
//             false,
//             false,
//             false
//           ],
//           chapterNames: [
//             'Introduction',
//             'Glory of Hanuman',
//             'Chalisa Part 1',
//             'Chalisa Part 2',
//             'Chalisa Part 3',
//             'Chalisa Part 4',
//             'Chalisa Part 5',
//           ],
//         );
//       },
//     );
//   }

//   void _showSpeedSelector(BuildContext context) {
//     final speeds = [0.5, 0.7, 1.0, 1.1, 1.2, 1.5];

//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           backgroundColor: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Select Speed',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: Colors.purple,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 ...speeds.map((speed) {
//                   final isSelected = speed == _playbackSpeed;
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _playbackSpeed = speed;
//                       });
//                       _videoController.setPlaybackSpeed(speed);
//                       Navigator.of(context).pop();
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 12, horizontal: 10),
//                       margin: const EdgeInsets.symmetric(vertical: 2),
//                       decoration: BoxDecoration(
//                         color:
//                             isSelected ? Color(0xFFD6B9F3) : Colors.transparent,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         "${speed}x",
//                         style: TextStyle(
//                           color: isSelected ? Colors.purple : Colors.black,
//                           fontWeight:
//                               isSelected ? FontWeight.bold : FontWeight.normal,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//                 const SizedBox(height: 4),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildNormalScreen(BuildContext context) {
//     final screenHeight = Get.height;
//     final screenWidth = Get.width;

//     return Scaffold(
//       backgroundColor: const Color(0xFFFCF9EE),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//                 const Icon(Icons.keyboard_arrow_left, size: 30),
//                 SizedBox(width: screenWidth * 0.22),
//                 Text("Hanuman Chalisa",
//                     style: GoogleFonts.poppins(
//                       fontSize: screenWidth * 0.045,
//                       fontWeight: FontWeight.w700,
//                       color: const Color(0xFF3A0084),
//                     )),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Column(
//               children: [
//                 CustomProgressBar(progress: 4 / 9),
//                 const SizedBox(height: 4),
//                 Text("2/9 Lessons Completed",
//                     style: GoogleFonts.poppins(fontSize: screenWidth * 0.035)),
//               ],
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               height: screenHeight * 0.66,
//               width: screenWidth * 0.9,
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _showControls = !_showControls;
//                   });
//                   if (!isPause) {
//                     _startHideControlsTimer();
//                   }
//                 },
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: isMusic
//                           ? Image.asset(
//                               "assets/icons/hanuman.png",
//                               fit: BoxFit.cover,
//                               height: screenHeight * 0.66,
//                               width: screenWidth * 0.9,
//                             )
//                           : _videoController.value.isInitialized
//                               ? FittedBox(
//                                   fit: BoxFit.cover,
//                                   child: SizedBox(
//                                     height: screenHeight * 0.66,
//                                     width: screenWidth * 0.9,
//                                     child: VideoPlayer(_videoController),
//                                   ),
//                                 )
//                               : Container(
//                                   color: Colors.grey,
//                                   height: screenHeight * 0.66,
//                                   width: screenWidth * 0.9,
//                                   child: const Center(
//                                       child: CircularProgressIndicator()),
//                                 ),
//                     ),
//                     if (_showBackwardIcon)
//                       const FaIcon(FontAwesomeIcons.backward,
//                           size: 50, color: Colors.white),
//                     if (_showForwardIcon)
//                       const FaIcon(FontAwesomeIcons.forward,
//                           size: 50, color: Colors.white),
//                     if (_showControls)
//                       Positioned(
//                         top: 12,
//                         left: 10,
//                         right: 10,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             GestureDetector(
//                               onTap: () => _showChapterDialog(context),
//                               child: Container(
//                                 width: screenWidth * 0.42,
//                                 height: screenHeight * 0.03,
//                                 decoration: BoxDecoration(
//                                   color: const Color.fromRGBO(30, 30, 30, 0.5),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 alignment: Alignment.center,
//                                 child: Text("2. Glory of Hanuman",
//                                     style: GoogleFonts.poppins(
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.white,
//                                       fontSize: screenWidth * 0.035,
//                                     )),
//                               ),
//                             ),

//                             GestureDetector(
//                               onTap: (){

//                               },
//                               child: _iconBox("assets/icons/Vector (8).svg"))
//                             // Row(
//                             //   children: [
//                             //     GestureDetector(
//                             //       onTap: () => _showSpeedSelector(context),
//                             //       child:
//                             //           _iconBox("assets/icons/Vector (7).svg"),
//                             //     ),
//                             //     const SizedBox(width: 5),
//                             //     GestureDetector(
//                             //       onTap: () async {
//                             //         final selectedLanguage = await showDialog(
//                             //           context: context,
//                             //           builder: (_) => LanguageSelectionDialog(),
//                             //         );
//                             //         if (selectedLanguage != null) {
//                             //           print(
//                             //               'Selected Language: $selectedLanguage');
//                             //         }
//                             //       },
//                             //       child: _iconBox("assets/icons/A.svg"),
//                             //     ),
//                             //     const SizedBox(width: 5),
//                             //     GestureDetector(
//                             //       onTap: _toggleMode,
//                             //       child: isMusic
//                             //           ? _iconBox("assets/icons/video.svg")
//                             //           : _iconBox("assets/icons/music.svg"),
//                             //     ),
//                             //   ],
//                             // ),
//                           ],
//                         ),
//                       ),
//                     if (_showControls)
//                       Positioned(
//                         top: screenHeight * 0.33,
//                         child: Row(
//                           children: [
//                             GestureDetector(
//                               onTap: _backward,
//                               child: const FaIcon(
//                                 FontAwesomeIcons.backwardStep,
//                                 color: Colors.white,
//                                 size: 30,
//                               ),
//                             ),
//                             const SizedBox(width: 50),
//                             GestureDetector(
//                               onTap: _togglePlayPause,
//                               child: FaIcon(
//                                 isPause
//                                     ? FontAwesomeIcons.play
//                                     : FontAwesomeIcons.pause,
//                                 color: Colors.white,
//                                 size: 30,
//                               ),
//                             ),
//                             const SizedBox(width: 50),
//                             GestureDetector(
//                               onTap: _forward,
//                               child: const FaIcon(
//                                 FontAwesomeIcons.forwardStep,
//                                 color: Colors.white,
//                                 size: 30,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     Positioned(
//                       bottom: 70,
//                       left: 20,
//                       right: 20,
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           "श्रीगुरु चरन सरोज रज, निज मनु मुकुर सुधारि।\nबरनऊँ रघुबर बिमल जसु, जो दायक फल चारि॥",
//                           style: GoogleFonts.poppins(
//                             color: Colors.white,
//                             fontSize: screenWidth * 0.045,
//                             height: 1.4,
//                           ),
//                           textAlign: TextAlign.start,
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 10,
//                       left: 10,
//                       right: 10,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Slider(
//                               min: 0,
//                               max: _videoController.value.duration.inSeconds
//                                   .toDouble(),
//                               value: _videoController.value.position.inSeconds
//                                   .clamp(0,
//                                       _videoController.value.duration.inSeconds)
//                                   .toDouble(),
//                               onChanged: (value) {
//                                 final seekTo = Duration(seconds: value.toInt());
//                                 _videoController.seekTo(seekTo);
//                               },
//                               activeColor: Colors.purple,
//                               inactiveColor: Colors.grey,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: _toggleFullScreen,
//                             child: Icon(
//                               Icons.fullscreen,
//                               size: 35,
//                               color: AppConstants.purpleColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFullScreen(BuildContext context) {
//     final screenHeight = Get.height;
//     final screenWidth = Get.width;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onTap: () {
//           setState(() {
//             _showControls = !_showControls;
//           });
//           if (!isPause) {
//             _startHideControlsTimer();
//           }
//         },
//         child: Stack(
//           children: [
//             Center(
//               child: isMusic
//                   ? Image.asset(
//                       "assets/icons/hanuman.png",
//                       fit: BoxFit.cover,
//                       height: screenHeight,
//                       width: screenWidth,
//                     )
//                   : _videoController.value.isInitialized
//                       ? AspectRatio(
//                           aspectRatio: 8 / 15.5,
//                           child: VideoPlayer(_videoController),
//                         )
//                       : Container(
//                           color: Colors.black,
//                           child:
//                               const Center(child: CircularProgressIndicator()),
//                         ),
//             ),
//             if (_showBackwardIcon)
//               const Center(
//                 child: FaIcon(FontAwesomeIcons.backward,
//                     size: 50, color: Colors.white),
//               ),
//             if (_showForwardIcon)
//               const Center(
//                 child: FaIcon(FontAwesomeIcons.forward,
//                     size: 50, color: Colors.white),
//               ),
//             if (_showControls)
//               Positioned(
//                 top: 30,
//                 left: 10,
//                 right: 10,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () => _showChapterDialog(context),
//                       child: Container(
//                         width: screenWidth * 0.42,
//                         height: screenHeight * 0.03,
//                         decoration: BoxDecoration(
//                           color: const Color.fromRGBO(30, 30, 30, 0.5),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         alignment: Alignment.center,
//                         child: Text("2. Glory of Hanuman",
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w500,
//                               color: Colors.white,
//                               fontSize: screenWidth * 0.035,
//                             )),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () => _showSpeedSelector(context),
//                           child: _iconBox("assets/icons/Vector (7).svg"),
//                         ),
//                         const SizedBox(width: 5),
//                         GestureDetector(
//                           onTap: () async {
//                             final selectedLanguage = await showDialog(
//                               context: context,
//                               builder: (_) => LanguageSelectionDialog(),
//                             );
//                             if (selectedLanguage != null) {
//                               print('Selected Language: $selectedLanguage');
//                             }
//                           },
//                           child: _iconBox("assets/icons/A.svg"),
//                         ),
//                         const SizedBox(width: 5),
//                         GestureDetector(
//                           onTap: _toggleMode,
//                           child: isMusic
//                               ? _iconBox("assets/icons/video.svg")
//                               : _iconBox("assets/icons/music.svg"),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             if (_showControls)
//               Positioned(
//                 bottom: Get.height * 0.45,
//                 left: 0,
//                 right: 0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: _backward,
//                       child: const FaIcon(
//                         FontAwesomeIcons.backwardStep,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                     SizedBox(width: Get.width * 0.2),
//                     GestureDetector(
//                       onTap: _togglePlayPause,
//                       child: FaIcon(
//                         isPause
//                             ? FontAwesomeIcons.play
//                             : FontAwesomeIcons.pause,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                     SizedBox(width: Get.width * 0.2),
//                     GestureDetector(
//                       onTap: _forward,
//                       child: const FaIcon(
//                         FontAwesomeIcons.forwardStep,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             Positioned(
//               bottom: 160,
//               left: 20,
//               right: 20,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   "श्रीगुरु चरन सरोज रज, निज मनु मुकुर सुधारि।\nबरनऊँ रघुबर बिमल जसु, जो दायक फल चारि॥",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: screenWidth * 0.045,
//                     height: 1.4,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 40,
//               left: 20,
//               right: 20,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Slider(
//                       min: 0,
//                       max: _videoController.value.duration.inSeconds.toDouble(),
//                       value: _videoController.value.position.inSeconds
//                           .clamp(0, _videoController.value.duration.inSeconds)
//                           .toDouble(),
//                       onChanged: (value) {
//                         final seekTo = Duration(seconds: value.toInt());
//                         _videoController.seekTo(seekTo);
//                       },
//                       activeColor: Colors.purple,
//                       inactiveColor: Colors.grey,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: _toggleFullScreen,
//                     child: Icon(
//                       Icons.fullscreen_exit,
//                       size: 35,
//                       color: AppConstants.purpleColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         _isFullScreen ? _buildFullScreen(context) : _buildNormalScreen(context),
//         if (!_isFullScreen || (_isFullScreen && _showControls))
//           Positioned(
//             left: Get.width * 0.5 - 22,
//             child: AnimatedContainer(
//               height: _isFullScreen ? Get.height * 1.58 : Get.height * 1.7,
//               duration: Duration(milliseconds: 300),
//               child: CircleAvatar(
//                 radius: 30,
//                 backgroundColor: AppConstants.purpleColor,
//                 child: const Center(
//                   child: FaIcon(
//                     FontAwesomeIcons.microphone,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _iconBox(dynamic svgPath) {
//     return Container(
//       height: Get.height * 0.030,
//       width: Get.width * 0.09,
//       padding: (svgPath == "assets/icons/Vector (7).svg")
//           ? EdgeInsets.all(Get.width * 0.017)
//           : (svgPath == "assets/icons/A.svg")
//               ? EdgeInsets.all(Get.width * 0.01)
//               : EdgeInsets.all(Get.width * 0.015),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(30, 30, 30, 0.4),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: SvgPicture.asset(
//         svgPath,
//         width: Get.width * 0.024,
//         height: Get.height * 0.016,
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:vedalaya_app/core/themes/app_constants.dart';
// import 'package:vedalaya_app/view/learning/modules/chapter_selection.dart';
// import 'package:vedalaya_app/view/learning/modules/custom_progressbar.dart';
// import 'package:vedalaya_app/view/learning/modules/language_selection.dart';
// import 'package:video_player/video_player.dart';

// class LearningScreen extends StatefulWidget {
//   const LearningScreen({super.key});

//   @override
//   State<LearningScreen> createState() => _LearningScreenState();
// }

// class _LearningScreenState extends State<LearningScreen> {
//   bool isPause = true;
//   bool isMusic = true;
//   late VideoPlayerController _videoController;

//   bool _showForwardIcon = false;
//   bool _showBackwardIcon = false;
//   bool _isFullScreen = false;
//   bool _showControls = true;
//   bool _showMenu = false;

//   double _playbackSpeed = 1.0;
//   Timer? _hideControlsTimer;

//   final String videoUrl =
//       'https://stream.mux.com/wlfOVYuv7OLpHOp17Hz75Kx00Vx6UeMf002k7uae01oo5k.m3u8';

//   @override
//   void initState() {
//     super.initState();

//     _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
//       ..initialize().then((_) {
//         setState(() {});
//         if (!isPause) _videoController.play();
//       });

//     _videoController.addListener(() {
//       if (mounted) setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _videoController.dispose();
//     _hideControlsTimer?.cancel();
//     super.dispose();
//   }

//   void _toggleMenu() {
//     setState(() {
//       _showMenu = !_showMenu;
//       if (_showMenu) {
//         _showControls = true;
//         _hideControlsTimer?.cancel();
//       }
//     });
//   }

//   void _toggleFullScreen() {
//     setState(() {
//       _isFullScreen = !_isFullScreen;
//       _showMenu = false;
//     });
//   }

//   void _startHideControlsTimer() {
//     _hideControlsTimer?.cancel();
//     _hideControlsTimer = Timer(const Duration(seconds: 2), () {
//       if (mounted && !isPause) {
//         setState(() {
//           _showControls = false;
//           _showMenu = false;
//         });
//       }
//     });
//   }

//   Future<void> _togglePlayPause() async {
//     setState(() {
//       isPause = !isPause;
//       _showMenu = false;
//     });

//     if (!isPause) {
//       await _videoController.play();
//       _startHideControlsTimer();
//     } else {
//       await _videoController.pause();
//       _hideControlsTimer?.cancel();
//     }

//     setState(() {
//       _showControls = true;
//     });
//   }

//   void _toggleMode() {
//     setState(() {
//       isMusic = !isMusic;
//       _showControls = true;
//       _showMenu = false;
//     });
//     if (!isPause) {
//       _startHideControlsTimer();
//     }
//   }

//   void _backward() {
//     final currentPosition = _videoController.value.position;
//     Duration newPosition = currentPosition - const Duration(seconds: 2);
//     if (newPosition < Duration.zero) newPosition = Duration.zero;
//     _videoController.seekTo(newPosition);

//     setState(() => _showBackwardIcon = true);
//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (mounted) setState(() => _showBackwardIcon = false);
//     });

//     setState(() {
//       _showControls = true;
//       _showMenu = false;
//     });
//     _startHideControlsTimer();
//   }

//   void _forward() {
//     final currentPosition = _videoController.value.position;
//     final duration = _videoController.value.duration;
//     Duration newPosition = currentPosition + const Duration(seconds: 2);
//     if (newPosition > duration) newPosition = duration;
//     _videoController.seekTo(newPosition);

//     setState(() => _showForwardIcon = true);
//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (mounted) setState(() => _showForwardIcon = false);
//     });

//     setState(() {
//       _showControls = true;
//       _showMenu = false;
//     });
//     _startHideControlsTimer();
//   }

//   void _showChapterDialog(BuildContext context) {
//     setState(() {
//       _showMenu = false;
//     });
//     showDialog(
//       context: context,
//       builder: (context) {
//         return ChapterSelectionDialog(
//           currentChapterIndex: 1,
//           chapterCompletionStatus: [
//             true,
//             true,
//             false,
//             false,
//             false,
//             false,
//             false
//           ],
//           chapterNames: [
//             'Introduction',
//             'Glory of Hanuman',
//             'Chalisa Part 1',
//             'Chalisa Part 2',
//             'Chalisa Part 3',
//             'Chalisa Part 4',
//             'Chalisa Part 5',
//           ],
//         );
//       },
//     );
//   }

//   void _showSpeedSelector(BuildContext context) {
//     setState(() {
//       _showMenu = false;
//     });
//     final speeds = [0.5, 0.7, 1.0, 1.1, 1.2, 1.5];

//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           backgroundColor: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Select Speed',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: Colors.purple,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 ...speeds.map((speed) {
//                   final isSelected = speed == _playbackSpeed;
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _playbackSpeed = speed;
//                       });
//                       _videoController.setPlaybackSpeed(speed);
//                       Navigator.of(context).pop();
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 12, horizontal: 10),
//                       margin: const EdgeInsets.symmetric(vertical: 2),
//                       decoration: BoxDecoration(
//                         color:
//                             isSelected ? Color(0xFFD6B9F3) : Colors.transparent,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         "${speed}x",
//                         style: TextStyle(
//                           color: isSelected ? Colors.purple : Colors.black,
//                           fontWeight:
//                               isSelected ? FontWeight.bold : FontWeight.normal,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//                 const SizedBox(height: 4),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildMenu(BuildContext context) {
//     return Positioned(
//       top: _isFullScreen ? 60 : 120,
//       right: _isFullScreen ? 30 : 40,
//       child: Container(
//         width: Get.width * 0.5,
//         decoration: BoxDecoration(
//           color: _isFullScreen ? Colors.white : Colors.white70,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Audio section
//             _buildMenuSection(
//               items: [
//                 _buildMenuItem(
//                   icon: "assets/icons/A.svg",
//                   text: "Subtitle",
//                   onTap: () {
//                     LanguageSelectionDialog();
//                   },
//                 ),
//                 _buildMenuItem(
//                   icon: "assets/icons/Vector (7).svg",
//                   text: "Speed",
//                   onTap: () => _showSpeedSelector(context),
//                 ),
//                 _buildMenuItem(
//                   icon: (isMusic)
//                       ? "assets/icons/video.svg"
//                       : "assets/icons/music.svg",
//                   text: (isMusic) ? "Video" : "Audio",
//                   onTap: () {
//                     _toggleMode();
//                   },
//                 ),
//                 _buildMenuItem(
//                   icon: "assets/icons/Vector (9).svg",
//                   text: "Auto Repeat",
//                   onTap: () {},
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuSection({required List<Widget> items}) {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 8),
//           ...items,
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuItem({
//     required String icon,
//     required String text,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: Row(
//           children: [
//             _iconBox(icon),
//             // Svg(icon, size: 20, color: Colors.grey[700]),
//             const SizedBox(width: 12),
//             Text(
//               text,
//               style: GoogleFonts.poppins(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[800],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNormalScreen(BuildContext context) {
//     final screenHeight = Get.height;
//     final screenWidth = Get.width;

//     return Scaffold(
//       backgroundColor: const Color(0xFFFCF9EE),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(Icons.keyboard_arrow_left, size: 30),
//                     SizedBox(width: screenWidth * 0.22),
//                     Text("Hanuman Chalisa",
//                         style: GoogleFonts.poppins(
//                           fontSize: screenWidth * 0.045,
//                           fontWeight: FontWeight.w700,
//                           color: const Color(0xFF3A0084),
//                         )),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Column(
//                   children: [
//                     CustomProgressBar(progress: 4 / 9),
//                     const SizedBox(height: 4),
//                     Text("2/9 Lessons Completed",
//                         style:
//                             GoogleFonts.poppins(fontSize: screenWidth * 0.035)),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 SizedBox(
//                   height: screenHeight * 0.66,
//                   width: screenWidth * 0.9,
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _showControls = !_showControls;
//                         _showMenu = false;
//                       });
//                       if (!isPause) {
//                         _startHideControlsTimer();
//                       }
//                     },
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: isMusic
//                               ? Image.asset(
//                                   "assets/icons/hanuman.png",
//                                   fit: BoxFit.cover,
//                                   height: screenHeight * 0.66,
//                                   width: screenWidth * 0.9,
//                                 )
//                               : _videoController.value.isInitialized
//                                   ? FittedBox(
//                                       fit: BoxFit.cover,
//                                       child: SizedBox(
//                                         height: screenHeight * 0.66,
//                                         width: screenWidth * 0.9,
//                                         child: VideoPlayer(_videoController),
//                                       ),
//                                     )
//                                   : Container(
//                                       color: Colors.grey,
//                                       height: screenHeight * 0.66,
//                                       width: screenWidth * 0.9,
//                                       child: const Center(
//                                           child: CircularProgressIndicator()),
//                                     ),
//                         ),
//                         if (_showBackwardIcon)
//                           const FaIcon(FontAwesomeIcons.backward,
//                               size: 50, color: Colors.white),
//                         if (_showForwardIcon)
//                           const FaIcon(FontAwesomeIcons.forward,
//                               size: 50, color: Colors.white),
//                         if (_showControls)
//                           Positioned(
//                             top: 12,
//                             left: 10,
//                             right: 10,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () => _showChapterDialog(context),
//                                   child: Container(
//                                     width: screenWidth * 0.42,
//                                     height: screenHeight * 0.03,
//                                     decoration: BoxDecoration(
//                                       color:
//                                           const Color.fromRGBO(30, 30, 30, 0.5),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     alignment: Alignment.center,
//                                     child: Text("2. Glory of Hanuman",
//                                         style: GoogleFonts.poppins(
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                           fontSize: screenWidth * 0.035,
//                                         )),
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: _toggleMenu,
//                                   child:
//                                       _iconBox("assets/icons/Vector (8).svg"),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         if (_showControls)
//                           Positioned(
//                             top: screenHeight * 0.33,
//                             child: Row(
//                               children: [
//                                 GestureDetector(
//                                   onTap: _backward,
//                                   child: const FaIcon(
//                                     FontAwesomeIcons.backwardStep,
//                                     color: Colors.white,
//                                     size: 30,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 50),
//                                 GestureDetector(
//                                   onTap: _togglePlayPause,
//                                   child: FaIcon(
//                                     isPause
//                                         ? FontAwesomeIcons.play
//                                         : FontAwesomeIcons.pause,
//                                     color: Colors.white,
//                                     size: 30,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 50),
//                                 GestureDetector(
//                                   onTap: _forward,
//                                   child: const FaIcon(
//                                     FontAwesomeIcons.forwardStep,
//                                     color: Colors.white,
//                                     size: 30,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         Positioned(
//                           bottom: 70,
//                           left: 20,
//                           right: 20,
//                           child: Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.5),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               "श्रीगुरु चरन सरोज रज, निज मनु मुकुर सुधारि।\nबरनऊँ रघुबर बिमल जसु, जो दायक फल चारि॥",
//                               style: GoogleFonts.poppins(
//                                 color: Colors.white,
//                                 fontSize: screenWidth * 0.045,
//                                 height: 1.4,
//                               ),
//                               textAlign: TextAlign.start,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 10,
//                           left: 10,
//                           right: 10,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Slider(
//                                   min: 0,
//                                   max: _videoController.value.duration.inSeconds
//                                       .toDouble(),
//                                   value: _videoController
//                                       .value.position.inSeconds
//                                       .clamp(
//                                           0,
//                                           _videoController
//                                               .value.duration.inSeconds)
//                                       .toDouble(),
//                                   onChanged: (value) {
//                                     final seekTo =
//                                         Duration(seconds: value.toInt());
//                                     _videoController.seekTo(seekTo);
//                                   },
//                                   activeColor: Colors.purple,
//                                   inactiveColor: Colors.grey,
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: _toggleFullScreen,
//                                 child: Icon(
//                                   Icons.fullscreen,
//                                   size: 35,
//                                   color: AppConstants.purpleColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//             if (_showMenu) _buildMenu(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFullScreen(BuildContext context) {
//     final screenHeight = Get.height;
//     final screenWidth = Get.width;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onTap: () {
//           setState(() {
//             _showControls = !_showControls;
//             _showMenu = false;
//           });
//           if (!isPause) {
//             _startHideControlsTimer();
//           }
//         },
//         child: Stack(
//           children: [
//             Center(
//               child: isMusic
//                   ? Image.asset(
//                       "assets/icons/hanuman.png",
//                       fit: BoxFit.cover,
//                       height: screenHeight,
//                       width: screenWidth,
//                     )
//                   : _videoController.value.isInitialized
//                       ? AspectRatio(
//                           aspectRatio: 8 / 15.5,
//                           child: VideoPlayer(_videoController),
//                         )
//                       : Container(
//                           color: Colors.black,
//                           child:
//                               const Center(child: CircularProgressIndicator()),
//                         ),
//             ),
//             if (_showBackwardIcon)
//               const Center(
//                 child: FaIcon(FontAwesomeIcons.backward,
//                     size: 50, color: Colors.white),
//               ),
//             if (_showForwardIcon)
//               const Center(
//                 child: FaIcon(FontAwesomeIcons.forward,
//                     size: 50, color: Colors.white),
//               ),
//             if (_showControls)
//               Positioned(
//                 top: 30,
//                 left: 10,
//                 right: 10,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () => _showChapterDialog(context),
//                       child: Container(
//                         width: screenWidth * 0.42,
//                         height: screenHeight * 0.03,
//                         decoration: BoxDecoration(
//                           color: const Color.fromRGBO(30, 30, 30, 0.5),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         alignment: Alignment.center,
//                         child: Text(
//                           "2. Glory of Hanuman",
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white,
//                             fontSize: screenWidth * 0.035,
//                           ),
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: _toggleMenu,
//                       child: _iconBox("assets/icons/Vector (8).svg"),
//                     ),
//                   ],
//                 ),
//               ),
//             if (_showControls)
//               Positioned(
//                 bottom: Get.height * 0.45,
//                 left: 0,
//                 right: 0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: _backward,
//                       child: const FaIcon(
//                         FontAwesomeIcons.backwardStep,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                     SizedBox(width: Get.width * 0.2),
//                     GestureDetector(
//                       onTap: _togglePlayPause,
//                       child: FaIcon(
//                         isPause
//                             ? FontAwesomeIcons.play
//                             : FontAwesomeIcons.pause,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                     SizedBox(width: Get.width * 0.2),
//                     GestureDetector(
//                       onTap: _forward,
//                       child: const FaIcon(
//                         FontAwesomeIcons.forwardStep,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             Positioned(
//               bottom: 160,
//               left: 20,
//               right: 20,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   "श्रीगुरु चरन सरोज रज, निज मनु मुकुर सुधारि।\nबरनऊँ रघुबर बिमल जसु, जो दायक फल चारि॥",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: screenWidth * 0.045,
//                     height: 1.4,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 40,
//               left: 20,
//               right: 20,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Slider(
//                       min: 0,
//                       max: _videoController.value.duration.inSeconds.toDouble(),
//                       value: _videoController.value.position.inSeconds
//                           .clamp(0, _videoController.value.duration.inSeconds)
//                           .toDouble(),
//                       onChanged: (value) {
//                         final seekTo = Duration(seconds: value.toInt());
//                         _videoController.seekTo(seekTo);
//                       },
//                       activeColor: Colors.purple,
//                       inactiveColor: Colors.grey,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: _toggleFullScreen,
//                     child: Icon(
//                       Icons.fullscreen_exit,
//                       size: 35,
//                       color: AppConstants.purpleColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (_showMenu) _buildMenu(context),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         _isFullScreen ? _buildFullScreen(context) : _buildNormalScreen(context),
//         if (!_isFullScreen || (_isFullScreen && _showControls))
//           Positioned(
//             left: Get.width * 0.5 - 22,
//             child: AnimatedContainer(
//               height: _isFullScreen ? Get.height * 1.58 : Get.height * 1.7,
//               duration: Duration(milliseconds: 300),
//               child: CircleAvatar(
//                 radius: 30,
//                 backgroundColor: AppConstants.purpleColor,
//                 child: const Center(
//                   child: FaIcon(
//                     FontAwesomeIcons.microphone,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _iconBox(dynamic svgPath) {
//     return Container(
//       height: Get.height * 0.030,
//       width: Get.width * 0.09,
//       padding: (svgPath == "assets/icons/Vector (7).svg")
//           ? EdgeInsets.all(Get.width * 0.017)
//           : (svgPath == "assets/icons/A.svg")
//               ? EdgeInsets.all(Get.width * 0.01)
//               : EdgeInsets.all(Get.width * 0.015),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(30, 30, 30, 0.4),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: SvgPicture.asset(
//         svgPath,
//         width: Get.width * 0.024,
//         height: Get.height * 0.016,
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:vedalaya_app/core/themes/app_constants.dart';
// import 'package:vedalaya_app/view/learning/modules/chapter_selection.dart';
// import 'package:vedalaya_app/view/learning/modules/custom_progressbar.dart';
// import 'package:vedalaya_app/view/learning/modules/language_selection.dart';
// import 'package:video_player/video_player.dart';

// class LearningScreen extends StatefulWidget {
//   const LearningScreen({super.key});

//   @override
//   State<LearningScreen> createState() => _LearningScreenState();
// }

// class _LearningScreenState extends State<LearningScreen> {
//   bool isPause = true;
//   bool isMusic = true;
//   late VideoPlayerController _videoController;

//   bool _showForwardIcon = false;
//   bool _showBackwardIcon = false;
//   bool _isFullScreen = false;
//   bool _showControls = true;
//   bool _showMenu = false;
//   bool _isVideoEnded = false;

//   double _playbackSpeed = 1.0;
//   Timer? _hideControlsTimer;
//   Timer? _endDialogTimer;

//   final String videoUrl =
//       'https://stream.mux.com/wlfOVYuv7OLpHOp17Hz75Kx00Vx6UeMf002k7uae01oo5k.m3u8';

//   @override
//   void initState() {
//     super.initState();

//     _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
//       ..initialize().then((_) {
//         setState(() {});
//         if (!isPause) _videoController.play();
//       });

//     _videoController.addListener(_videoListener);
//   }

//   void _videoListener() {
//     if (!_videoController.value.isInitialized) return;

//     // Check if video reached the end
//     if (_videoController.value.position >= _videoController.value.duration &&
//         !_isVideoEnded &&
//         _videoController.value.duration > Duration.zero) {
//       setState(() {
//         _isVideoEnded = true;
//       });
//       // Show dialog when video ends
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _showEndOfVideoDialog(context);
//       });
//     } else if (_videoController.value.position <
//         _videoController.value.duration) {
//       _isVideoEnded = false;
//     }

//     if (mounted) setState(() {});
//   }

//   void _showEndOfVideoDialog(BuildContext context) {
//     // Cancel any existing timer
//     _endDialogTimer?.cancel();

//     // Start countdown timer
//     int countdown = 2;
//     _endDialogTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (countdown > 0) {
//         setState(() {
//           countdown--;
//         });
//       } else {
//         timer.cancel();
//         if (mounted && Navigator.of(context).canPop()) {
//           Navigator.of(context, rootNavigator: true).pop();
//         }
//       }
//     });

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16.0),
//           ),
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Play Again in",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   "00:0${_endDialogTimer != null ? 5 - (_endDialogTimer!.tick - 1) : 5}",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: AppConstants.purpleColor,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppConstants.purpleColor,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     onPressed: () {
//                       _endDialogTimer?.cancel();
//                       Navigator.of(context, rootNavigator: true).pop();
//                       _replayVideo();
//                     },
//                     child: const Text(
//                       "Replay Now",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _replayVideo() {
//     setState(() {
//       _isVideoEnded = false;
//     });
//     _videoController
//       ..seekTo(Duration.zero)
//       ..play();
//   }

//   @override
//   void dispose() {
//     _videoController.removeListener(_videoListener);
//     _videoController.dispose();
//     _hideControlsTimer?.cancel();
//     _endDialogTimer?.cancel();
//     super.dispose();
//   }

//   void _toggleMenu() {
//     setState(() {
//       _showMenu = !_showMenu;
//       if (_showMenu) {
//         _showControls = true;
//         _hideControlsTimer?.cancel();
//       }
//     });
//   }

//   void _toggleFullScreen() {
//     setState(() {
//       _isFullScreen = !_isFullScreen;
//       _showMenu = false;
//     });
//   }

//   void _startHideControlsTimer() {
//     _hideControlsTimer?.cancel();
//     _hideControlsTimer = Timer(const Duration(seconds: 2), () {
//       if (mounted && !isPause) {
//         setState(() {
//           _showControls = false;
//           _showMenu = false;
//         });
//       }
//     });
//   }

//   Future<void> _togglePlayPause() async {
//     setState(() {
//       isPause = !isPause;
//       _showMenu = false;
//     });

//     if (!isPause) {
//       await _videoController.play();
//       _startHideControlsTimer();
//     } else {
//       await _videoController.pause();
//       _hideControlsTimer?.cancel();
//     }

//     setState(() {
//       _showControls = true;
//     });
//   }

//   void _toggleMode() {
//     setState(() {
//       isMusic = !isMusic;
//       _showControls = true;
//       _showMenu = false;
//     });
//     if (!isPause) {
//       _startHideControlsTimer();
//     }
//   }

//   void _backward() {
//     final currentPosition = _videoController.value.position;
//     Duration newPosition = currentPosition - const Duration(seconds: 2);
//     if (newPosition < Duration.zero) newPosition = Duration.zero;
//     _videoController.seekTo(newPosition);

//     setState(() => _showBackwardIcon = true);
//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (mounted) setState(() => _showBackwardIcon = false);
//     });

//     setState(() {
//       _showControls = true;
//       _showMenu = false;
//     });
//     _startHideControlsTimer();
//   }

//   void _forward() {
//     final currentPosition = _videoController.value.position;
//     final duration = _videoController.value.duration;
//     Duration newPosition = currentPosition + const Duration(seconds: 2);
//     if (newPosition > duration) newPosition = duration;
//     _videoController.seekTo(newPosition);

//     setState(() => _showForwardIcon = true);
//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (mounted) setState(() => _showForwardIcon = false);
//     });

//     setState(() {
//       _showControls = true;
//       _showMenu = false;
//     });
//     _startHideControlsTimer();
//   }

//   void _showChapterDialog(BuildContext context) {
//     setState(() {
//       _showMenu = false;
//     });
//     showDialog(
//       context: context,
//       builder: (context) {
//         return ChapterSelectionDialog(
//           currentChapterIndex: 1,
//           chapterCompletionStatus: [
//             true,
//             true,
//             false,
//             false,
//             false,
//             false,
//             false
//           ],
//           chapterNames: [
//             'Introduction',
//             'Glory of Hanuman',
//             'Chalisa Part 1',
//             'Chalisa Part 2',
//             'Chalisa Part 3',
//             'Chalisa Part 4',
//             'Chalisa Part 5',
//           ],
//         );
//       },
//     );
//   }

//   void _showSpeedSelector(BuildContext context) {
//     setState(() {
//       _showMenu = false;
//     });
//     final speeds = [0.5, 0.7, 1.0, 1.1, 1.2, 1.5];

//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           backgroundColor: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Select Speed',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: Colors.purple,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 ...speeds.map((speed) {
//                   final isSelected = speed == _playbackSpeed;
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _playbackSpeed = speed;
//                       });
//                       _videoController.setPlaybackSpeed(speed);
//                       Navigator.of(context).pop();
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 12, horizontal: 10),
//                       margin: const EdgeInsets.symmetric(vertical: 2),
//                       decoration: BoxDecoration(
//                         color:
//                             isSelected ? Color(0xFFD6B9F3) : Colors.transparent,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         "${speed}x",
//                         style: TextStyle(
//                           color: isSelected ? Colors.purple : Colors.black,
//                           fontWeight:
//                               isSelected ? FontWeight.bold : FontWeight.normal,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//                 const SizedBox(height: 4),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildMenu(BuildContext context) {
//     return Positioned(
//       top: _isFullScreen ? 60 : 120,
//       right: _isFullScreen ? 30 : 40,
//       child: Container(
//         width: Get.width * 0.5,
//         decoration: BoxDecoration(
//           color: _isFullScreen ? Colors.white : Colors.white70,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Audio section
//             _buildMenuSection(
//               items: [
//                 _buildMenuItem(
//                   icon: "assets/icons/A.svg",
//                   text: "Subtitle",
//                   onTap: () {
//                     LanguageSelectionDialog();
//                   },
//                 ),
//                 _buildMenuItem(
//                   icon: "assets/icons/Vector (7).svg",
//                   text: "Speed",
//                   onTap: () => _showSpeedSelector(context),
//                 ),
//                 _buildMenuItem(
//                   icon: (isMusic)
//                       ? "assets/icons/video.svg"
//                       : "assets/icons/music.svg",
//                   text: (isMusic) ? "Video" : "Audio",
//                   onTap: () {
//                     _toggleMode();
//                   },
//                 ),
//                 _buildMenuItem(
//                   icon: "assets/icons/Vector (9).svg",
//                   text: "Auto Repeat",
//                   onTap: () {
//                     _replayVideo();
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuSection({required List<Widget> items}) {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 8),
//           ...items,
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuItem({
//     required String icon,
//     required String text,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: Row(
//           children: [
//             _iconBox(icon),
//             // Svg(icon, size: 20, color: Colors.grey[700]),
//             const SizedBox(width: 12),
//             Text(
//               text,
//               style: GoogleFonts.poppins(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[800],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNormalScreen(BuildContext context) {
//     final screenHeight = Get.height;
//     final screenWidth = Get.width;

//     return Scaffold(
//       backgroundColor: const Color(0xFFFCF9EE),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(Icons.keyboard_arrow_left, size: 30),
//                     SizedBox(width: screenWidth * 0.22),
//                     Text("Hanuman Chalisa",
//                         style: GoogleFonts.poppins(
//                           fontSize: screenWidth * 0.045,
//                           fontWeight: FontWeight.w700,
//                           color: const Color(0xFF3A0084),
//                         )),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Column(
//                   children: [
//                     CustomProgressBar(progress: 4 / 9),
//                     const SizedBox(height: 4),
//                     Text("2/9 Lessons Completed",
//                         style:
//                             GoogleFonts.poppins(fontSize: screenWidth * 0.035)),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 SizedBox(
//                   height: screenHeight * 0.66,
//                   width: screenWidth * 0.9,
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _showControls = !_showControls;
//                         _showMenu = false;
//                       });
//                       if (!isPause) {
//                         _startHideControlsTimer();
//                       }
//                     },
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: isMusic
//                               ? Image.asset(
//                                   "assets/icons/hanuman.png",
//                                   fit: BoxFit.cover,
//                                   height: screenHeight * 0.66,
//                                   width: screenWidth * 0.9,
//                                 )
//                               : _videoController.value.isInitialized
//                                   ? FittedBox(
//                                       fit: BoxFit.cover,
//                                       child: SizedBox(
//                                         height: screenHeight * 0.66,
//                                         width: screenWidth * 0.9,
//                                         child: VideoPlayer(_videoController),
//                                       ),
//                                     )
//                                   : Container(
//                                       color: Colors.grey,
//                                       height: screenHeight * 0.66,
//                                       width: screenWidth * 0.9,
//                                       child: const Center(
//                                           child: CircularProgressIndicator()),
//                                     ),
//                         ),
//                         if (_showBackwardIcon)
//                           const FaIcon(FontAwesomeIcons.backward,
//                               size: 50, color: Colors.white),
//                         if (_showForwardIcon)
//                           const FaIcon(FontAwesomeIcons.forward,
//                               size: 50, color: Colors.white),
//                         if (_showControls)
//                           Positioned(
//                             top: 12,
//                             left: 10,
//                             right: 10,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () => _showChapterDialog(context),
//                                   child: Container(
//                                     width: screenWidth * 0.42,
//                                     height: screenHeight * 0.03,
//                                     decoration: BoxDecoration(
//                                       color:
//                                           const Color.fromRGBO(30, 30, 30, 0.5),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     alignment: Alignment.center,
//                                     child: Text("2. Glory of Hanuman",
//                                         style: GoogleFonts.poppins(
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                           fontSize: screenWidth * 0.035,
//                                         )),
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: _toggleMenu,
//                                   child:
//                                       _iconBox("assets/icons/Vector (8).svg"),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         if (_showControls)
//                           Positioned(
//                             top: screenHeight * 0.33,
//                             child: Row(
//                               children: [
//                                 GestureDetector(
//                                   onTap: _backward,
//                                   child: const FaIcon(
//                                     FontAwesomeIcons.backwardStep,
//                                     color: Colors.white,
//                                     size: 30,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 50),
//                                 GestureDetector(
//                                   onTap: _togglePlayPause,
//                                   child: FaIcon(
//                                     isPause
//                                         ? FontAwesomeIcons.play
//                                         : FontAwesomeIcons.pause,
//                                     color: Colors.white,
//                                     size: 30,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 50),
//                                 GestureDetector(
//                                   onTap: _forward,
//                                   child: const FaIcon(
//                                     FontAwesomeIcons.forwardStep,
//                                     color: Colors.white,
//                                     size: 30,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         Positioned(
//                           bottom: 70,
//                           left: 20,
//                           right: 20,
//                           child: Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.5),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               "श्रीगुरु चरन सरोज रज, निज मनु मुकुर सुधारि।\nबरनऊँ रघुबर बिमल जसु, जो दायक फल चारि॥",
//                               style: GoogleFonts.poppins(
//                                 color: Colors.white,
//                                 fontSize: screenWidth * 0.045,
//                                 height: 1.4,
//                               ),
//                               textAlign: TextAlign.start,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 10,
//                           left: 10,
//                           right: 10,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Slider(
//                                   min: 0,
//                                   max: _videoController.value.duration.inSeconds
//                                       .toDouble(),
//                                   value: _videoController
//                                       .value.position.inSeconds
//                                       .clamp(
//                                           0,
//                                           _videoController
//                                               .value.duration.inSeconds)
//                                       .toDouble(),
//                                   onChanged: (value) {
//                                     final seekTo =
//                                         Duration(seconds: value.toInt());
//                                     _videoController.seekTo(seekTo);
//                                   },
//                                   activeColor: Colors.purple,
//                                   inactiveColor: Colors.grey,
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: _toggleFullScreen,
//                                 child: Icon(
//                                   Icons.fullscreen,
//                                   size: 35,
//                                   color: AppConstants.purpleColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//             if (_showMenu) _buildMenu(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFullScreen(BuildContext context) {
//     final screenHeight = Get.height;
//     final screenWidth = Get.width;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onTap: () {
//           setState(() {
//             _showControls = !_showControls;
//             _showMenu = false;
//           });
//           if (!isPause) {
//             _startHideControlsTimer();
//           }
//         },
//         child: Stack(
//           children: [
//             Center(
//               child: isMusic
//                   ? Image.asset(
//                       "assets/icons/hanuman.png",
//                       fit: BoxFit.cover,
//                       height: screenHeight,
//                       width: screenWidth,
//                     )
//                   : _videoController.value.isInitialized
//                       ? AspectRatio(
//                           aspectRatio: 8 / 15.5,
//                           child: VideoPlayer(_videoController),
//                         )
//                       : Container(
//                           color: Colors.black,
//                           child:
//                               const Center(child: CircularProgressIndicator()),
//                         ),
//             ),
//             if (_showBackwardIcon)
//               const Center(
//                 child: FaIcon(FontAwesomeIcons.backward,
//                     size: 50, color: Colors.white),
//               ),
//             if (_showForwardIcon)
//               const Center(
//                 child: FaIcon(FontAwesomeIcons.forward,
//                     size: 50, color: Colors.white),
//               ),
//             if (_showControls)
//               Positioned(
//                 top: 30,
//                 left: 10,
//                 right: 10,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () => _showChapterDialog(context),
//                       child: Container(
//                         width: screenWidth * 0.42,
//                         height: screenHeight * 0.03,
//                         decoration: BoxDecoration(
//                           color: const Color.fromRGBO(30, 30, 30, 0.5),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         alignment: Alignment.center,
//                         child: Text(
//                           "2. Glory of Hanuman",
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white,
//                             fontSize: screenWidth * 0.035,
//                           ),
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: _toggleMenu,
//                       child: _iconBox("assets/icons/Vector (8).svg"),
//                     ),
//                   ],
//                 ),
//               ),
//             if (_showControls)
//               Positioned(
//                 bottom: Get.height * 0.45,
//                 left: 0,
//                 right: 0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: _backward,
//                       child: const FaIcon(
//                         FontAwesomeIcons.backwardStep,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                     SizedBox(width: Get.width * 0.2),
//                     GestureDetector(
//                       onTap: _togglePlayPause,
//                       child: FaIcon(
//                         isPause
//                             ? FontAwesomeIcons.play
//                             : FontAwesomeIcons.pause,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                     SizedBox(width: Get.width * 0.2),
//                     GestureDetector(
//                       onTap: _forward,
//                       child: const FaIcon(
//                         FontAwesomeIcons.forwardStep,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             Positioned(
//               bottom: 160,
//               left: 20,
//               right: 20,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   "श्रीगुरु चरन सरोज रज, निज मनु मुकुर सुधारि।\nबरनऊँ रघुबर बिमल जसु, जो दायक फल चारि॥",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: screenWidth * 0.045,
//                     height: 1.4,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 40,
//               left: 20,
//               right: 20,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Slider(
//                       min: 0,
//                       max: _videoController.value.duration.inSeconds.toDouble(),
//                       value: _videoController.value.position.inSeconds
//                           .clamp(0, _videoController.value.duration.inSeconds)
//                           .toDouble(),
//                       onChanged: (value) {
//                         final seekTo = Duration(seconds: value.toInt());
//                         _videoController.seekTo(seekTo);
//                       },
//                       activeColor: Colors.purple,
//                       inactiveColor: Colors.grey,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: _toggleFullScreen,
//                     child: Icon(
//                       Icons.fullscreen_exit,
//                       size: 35,
//                       color: AppConstants.purpleColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (_showMenu) _buildMenu(context),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         _isFullScreen ? _buildFullScreen(context) : _buildNormalScreen(context),
//         if (!_isFullScreen || (_isFullScreen && _showControls))
//           Positioned(
//             left: Get.width * 0.5 - 22,
//             child: AnimatedContainer(
//               height: _isFullScreen ? Get.height * 1.58 : Get.height * 1.7,
//               duration: Duration(milliseconds: 300),
//               child: CircleAvatar(
//                 radius: 30,
//                 backgroundColor: AppConstants.purpleColor,
//                 child: const Center(
//                   child: FaIcon(
//                     FontAwesomeIcons.microphone,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _iconBox(dynamic svgPath) {
//     return Container(
//       height: Get.height * 0.030,
//       width: Get.width * 0.075,
//       padding: (svgPath == "assets/icons/Vector (7).svg")
//           ? EdgeInsets.all(Get.width * 0.017)
//           : (svgPath == "assets/icons/A.svg")
//               ? EdgeInsets.all(Get.width * 0.01)
//               : EdgeInsets.all(Get.width * 0.015),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(30, 30, 30, 0.4),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: SvgPicture.asset(
//         svgPath,
//         width: Get.width * 0.024,
//         height: Get.height * 0.016,
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:vedalaya_app/core/themes/app_constants.dart';
// import 'package:vedalaya_app/view/learning/modules/chapter_selection.dart';
// import 'package:vedalaya_app/view/learning/modules/custom_progressbar.dart';
// import 'package:vedalaya_app/view/learning/modules/language_selection.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter/services.dart' show rootBundle;

// class LearningScreen extends StatefulWidget {
//   const LearningScreen({super.key});

//   @override
//   State<LearningScreen> createState() => _LearningScreenState();
// }

// class _LearningScreenState extends State<LearningScreen> {
//   bool isPause = true;
//   bool isMusic = true;
//   late VideoPlayerController _videoController;

//   bool _showForwardIcon = false;
//   bool _showBackwardIcon = false;
//   bool _isFullScreen = false;
//   bool _showControls = true;
//   bool _showMenu = false;
//   bool _isVideoEnded = false;

//   double _playbackSpeed = 1.0;
//   Timer? _hideControlsTimer;
//   Timer? _endDialogTimer;

//   List<Subtitle> subtitles = [];
//   String currentSubtitle = "";
//   Timer? _subtitleTimer;

//   final String videoUrl =
//       'https://stream.mux.com/wlfOVYuv7OLpHOp17Hz75Kx00Vx6UeMf002k7uae01oo5k.m3u8';

//   @override
//   void initState() {
//     super.initState();

//     _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
//       ..initialize().then((_) {
//         setState(() {});
//         if (!isPause) _videoController.play();
//       });

//     _videoController.addListener(_videoListener);
//     _loadSubtitles();
//   }

//   Future<void> _loadSubtitles() async {
//     try {
//       final srtContent =
//           await rootBundle.loadString('assets/icons/HanumanChalisa.srt');
//       subtitles = parseSrt(srtContent);
//       _startSubtitleUpdates();
//     } catch (e) {
//       print("Error loading subtitles: $e");
//     }
//   }

//   List<Subtitle> parseSrt(String srtContent) {
//     final subtitles = <Subtitle>[];
//     final blocks = srtContent.split('\n\n');

//     for (final block in blocks) {
//       final lines = block.split('\n');
//       if (lines.length >= 3) {
//         final timeParts = lines[1].split(' --> ');
//         if (timeParts.length == 2) {
//           final startTime = _parseSrtTime(timeParts[0].trim());
//           final endTime = _parseSrtTime(timeParts[1].trim());
//           final text = lines.sublist(2).join('\n');
//           subtitles.add(Subtitle(startTime, endTime, text));
//         }
//       }
//     }

//     return subtitles;
//   }

//   Duration _parseSrtTime(String timeString) {
//     final parts = timeString.split(':');
//     if (parts.length == 3) {
//       final secondsParts = parts[2].split(',');
//       final hours = int.parse(parts[0]);
//       final minutes = int.parse(parts[1]);
//       final seconds = int.parse(secondsParts[0]);
//       final milliseconds =
//           secondsParts.length > 1 ? int.parse(secondsParts[1]) : 0;
//       return Duration(
//         hours: hours,
//         minutes: minutes,
//         seconds: seconds,
//         milliseconds: milliseconds,
//       );
//     }
//     return Duration.zero;
//   }

//   void _startSubtitleUpdates() {
//     _subtitleTimer?.cancel();
//     _subtitleTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (!_videoController.value.isInitialized || isPause) return;

//       final currentPosition = _videoController.value.position;
//       final currentSub = subtitles.firstWhere(
//         (sub) => currentPosition >= sub.start && currentPosition <= sub.end,
//         orElse: () => Subtitle(Duration.zero, Duration.zero, ""),
//       );

//       if (currentSub.text != currentSubtitle) {
//         setState(() {
//           currentSubtitle = currentSub.text;
//         });
//       }
//     });
//   }

//   void _videoListener() {
//     if (!_videoController.value.isInitialized) return;

//     // Check if video reached the end
//     if (_videoController.value.position >= _videoController.value.duration &&
//         !_isVideoEnded &&
//         _videoController.value.duration > Duration.zero) {
//       setState(() {
//         _isVideoEnded = true;
//       });
//       // Show dialog when video ends
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _showEndOfVideoDialog(context);
//       });
//     } else if (_videoController.value.position <
//         _videoController.value.duration) {
//       _isVideoEnded = false;
//     }

//     if (mounted) setState(() {});
//   }

//   void _showEndOfVideoDialog(BuildContext context) {
//     _endDialogTimer?.cancel();
//     int countdown = 2;
//     _endDialogTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (countdown > 0) {
//         setState(() {
//           countdown--;
//         });
//       } else {
//         timer.cancel();
//         if (mounted && Navigator.of(context).canPop()) {
//           Navigator.of(context, rootNavigator: true).pop();
//         }
//       }
//     });

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16.0),
//           ),
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Play Again in",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   "00:0${_endDialogTimer != null ? 5 - (_endDialogTimer!.tick - 1) : 5}",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: AppConstants.purpleColor,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppConstants.purpleColor,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     onPressed: () {
//                       _endDialogTimer?.cancel();
//                       Navigator.of(context, rootNavigator: true).pop();
//                       _replayVideo();
//                     },
//                     child: const Text(
//                       "Replay Now",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _replayVideo() {
//     setState(() {
//       _isVideoEnded = false;
//     });
//     _videoController
//       ..seekTo(Duration.zero)
//       ..play();
//   }

//   @override
//   void dispose() {
//     _videoController.removeListener(_videoListener);
//     _videoController.dispose();
//     _hideControlsTimer?.cancel();
//     _endDialogTimer?.cancel();
//     _subtitleTimer?.cancel();
//     super.dispose();
//   }

//   void _toggleMenu() {
//     setState(() {
//       _showMenu = !_showMenu;
//       if (_showMenu) {
//         _showControls = true;
//         _hideControlsTimer?.cancel();
//       }
//     });
//   }

//   void _toggleFullScreen() {
//     setState(() {
//       _isFullScreen = !_isFullScreen;
//       _showMenu = false;
//     });
//   }

//   void _startHideControlsTimer() {
//     _hideControlsTimer?.cancel();
//     _hideControlsTimer = Timer(const Duration(seconds: 2), () {
//       if (mounted && !isPause) {
//         setState(() {
//           _showControls = false;
//           _showMenu = false;
//         });
//       }
//     });
//   }

//   Future<void> _togglePlayPause() async {
//     setState(() {
//       isPause = !isPause;
//       _showMenu = false;
//     });

//     if (!isPause) {
//       await _videoController.play();
//       _startSubtitleUpdates();
//       _startHideControlsTimer();
//     } else {
//       await _videoController.pause();
//       _subtitleTimer?.cancel();
//       _hideControlsTimer?.cancel();
//     }

//     setState(() {
//       _showControls = true;
//     });
//   }

//   void _toggleMode() {
//     setState(() {
//       isMusic = !isMusic;
//       _showControls = true;
//       _showMenu = false;
//     });
//     if (!isPause) {
//       _startHideControlsTimer();
//     }
//   }

//   void _backward() {
//     final currentPosition = _videoController.value.position;
//     Duration newPosition = currentPosition - const Duration(seconds: 2);
//     if (newPosition < Duration.zero) newPosition = Duration.zero;
//     _videoController.seekTo(newPosition);

//     setState(() => _showBackwardIcon = true);
//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (mounted) setState(() => _showBackwardIcon = false);
//     });

//     setState(() {
//       _showControls = true;
//       _showMenu = false;
//     });
//     _startHideControlsTimer();
//   }

//   void _forward() {
//     final currentPosition = _videoController.value.position;
//     final duration = _videoController.value.duration;
//     Duration newPosition = currentPosition + const Duration(seconds: 2);
//     if (newPosition > duration) newPosition = duration;
//     _videoController.seekTo(newPosition);

//     setState(() => _showForwardIcon = true);
//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (mounted) setState(() => _showForwardIcon = false);
//     });

//     setState(() {
//       _showControls = true;
//       _showMenu = false;
//     });
//     _startHideControlsTimer();
//   }

//   void _showChapterDialog(BuildContext context) {
//     setState(() {
//       _showMenu = false;
//     });
//     showDialog(
//       context: context,
//       builder: (context) {
//         return ChapterSelectionDialog(
//           currentChapterIndex: 1,
//           chapterCompletionStatus: [
//             true,
//             true,
//             false,
//             false,
//             false,
//             false,
//             false
//           ],
//           chapterNames: [
//             'Introduction',
//             'Glory of Hanuman',
//             'Chalisa Part 1',
//             'Chalisa Part 2',
//             'Chalisa Part 3',
//             'Chalisa Part 4',
//             'Chalisa Part 5',
//           ],
//         );
//       },
//     );
//   }

//   void _showSpeedSelector(BuildContext context) {
//     setState(() {
//       _showMenu = false;
//     });
//     final speeds = [0.5, 0.7, 1.0, 1.1, 1.2, 1.5];

//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           backgroundColor: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Select Speed',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: Colors.purple,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 ...speeds.map((speed) {
//                   final isSelected = speed == _playbackSpeed;
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _playbackSpeed = speed;
//                       });
//                       _videoController.setPlaybackSpeed(speed);
//                       Navigator.of(context).pop();
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 12, horizontal: 10),
//                       margin: const EdgeInsets.symmetric(vertical: 2),
//                       decoration: BoxDecoration(
//                         color:
//                             isSelected ? Color(0xFFD6B9F3) : Colors.transparent,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         "${speed}x",
//                         style: TextStyle(
//                           color: isSelected ? Colors.purple : Colors.black,
//                           fontWeight:
//                               isSelected ? FontWeight.bold : FontWeight.normal,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//                 const SizedBox(height: 4),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildMenu(BuildContext context) {
//     return Positioned(
//       top: _isFullScreen ? 60 : 120,
//       right: _isFullScreen ? 30 : 40,
//       child: Container(
//         width: Get.width * 0.5,
//         decoration: BoxDecoration(
//           color: _isFullScreen ? Colors.white : Colors.white70,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildMenuSection(
//               items: [
//                 _buildMenuItem(
//                   icon: "assets/icons/A.svg",
//                   text: "Subtitle",
//                   onTap: () {
//                     LanguageSelectionDialog();
//                   },
//                 ),
//                 _buildMenuItem(
//                   icon: "assets/icons/Vector (7).svg",
//                   text: "Speed",
//                   onTap: () => _showSpeedSelector(context),
//                 ),
//                 _buildMenuItem(
//                   icon: (isMusic)
//                       ? "assets/icons/video.svg"
//                       : "assets/icons/music.svg",
//                   text: (isMusic) ? "Video" : "Audio",
//                   onTap: () {
//                     _toggleMode();
//                   },
//                 ),
//                 _buildMenuItem(
//                   icon: "assets/icons/Vector (9).svg",
//                   text: "Auto Repeat",
//                   onTap: () {
//                     _replayVideo();
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuSection({required List<Widget> items}) {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 8),
//           ...items,
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuItem({
//     required String icon,
//     required String text,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: Row(
//           children: [
//             _iconBox(icon),
//             const SizedBox(width: 12),
//             Text(
//               text,
//               style: GoogleFonts.poppins(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[800],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNormalScreen(BuildContext context) {
//     final screenHeight = Get.height;
//     final screenWidth = Get.width;

//     return Scaffold(
//       backgroundColor: const Color(0xFFFCF9EE),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(Icons.keyboard_arrow_left, size: 30),
//                     SizedBox(width: screenWidth * 0.22),
//                     Text("Hanuman Chalisa",
//                         style: GoogleFonts.poppins(
//                           fontSize: screenWidth * 0.045,
//                           fontWeight: FontWeight.w700,
//                           color: const Color(0xFF3A0084),
//                         )),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Column(
//                   children: [
//                     CustomProgressBar(progress: 4 / 9),
//                     const SizedBox(height: 4),
//                     Text("2/9 Lessons Completed",
//                         style:
//                             GoogleFonts.poppins(fontSize: screenWidth * 0.035)),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 SizedBox(
//                   height: screenHeight * 0.66,
//                   width: screenWidth * 0.9,
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _showControls = !_showControls;
//                         _showMenu = false;
//                       });
//                       if (!isPause) {
//                         _startHideControlsTimer();
//                       }
//                     },
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: isMusic
//                               ? Image.asset(
//                                   "assets/icons/hanuman.png",
//                                   fit: BoxFit.cover,
//                                   height: screenHeight * 0.66,
//                                   width: screenWidth * 0.9,
//                                 )
//                               : _videoController.value.isInitialized
//                                   ? FittedBox(
//                                       fit: BoxFit.cover,
//                                       child: SizedBox(
//                                         height: screenHeight * 0.66,
//                                         width: screenWidth * 0.9,
//                                         child: VideoPlayer(_videoController),
//                                       ),
//                                     )
//                                   : Container(
//                                       color: Colors.grey,
//                                       height: screenHeight * 0.66,
//                                       width: screenWidth * 0.9,
//                                       child: const Center(
//                                           child: CircularProgressIndicator()),
//                                     ),
//                         ),
//                         if (_showBackwardIcon)
//                           const FaIcon(FontAwesomeIcons.backward,
//                               size: 50, color: Colors.white),
//                         if (_showForwardIcon)
//                           const FaIcon(FontAwesomeIcons.forward,
//                               size: 50, color: Colors.white),
//                         if (_showControls)
//                           Positioned(
//                             top: 12,
//                             left: 10,
//                             right: 10,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () => _showChapterDialog(context),
//                                   child: Container(
//                                     width: screenWidth * 0.42,
//                                     height: screenHeight * 0.03,
//                                     decoration: BoxDecoration(
//                                       color:
//                                           const Color.fromRGBO(30, 30, 30, 0.5),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     alignment: Alignment.center,
//                                     child: Text("2. Glory of Hanuman",
//                                         style: GoogleFonts.poppins(
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                           fontSize: screenWidth * 0.035,
//                                         )),
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: _toggleMenu,
//                                   child:
//                                       _iconBox("assets/icons/Vector (8).svg"),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         if (_showControls)
//                           Positioned(
//                             top: screenHeight * 0.33,
//                             child: Row(
//                               children: [
//                                 GestureDetector(
//                                   onTap: _backward,
//                                   child: const FaIcon(
//                                     FontAwesomeIcons.backwardStep,
//                                     color: Colors.white,
//                                     size: 30,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 50),
//                                 GestureDetector(
//                                   onTap: _togglePlayPause,
//                                   child: FaIcon(
//                                     isPause
//                                         ? FontAwesomeIcons.play
//                                         : FontAwesomeIcons.pause,
//                                     color: Colors.white,
//                                     size: 30,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 50),
//                                 GestureDetector(
//                                   onTap: _forward,
//                                   child: const FaIcon(
//                                     FontAwesomeIcons.forwardStep,
//                                     color: Colors.white,
//                                     size: 30,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         Positioned(
//                           bottom: 70,
//                           left: 20,
//                           right: 20,
//                           child: Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.5),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               currentSubtitle.isNotEmpty
//                                   ? currentSubtitle
//                                   : "श्रीगुरु चरन सरोज रज, निज मनु मुकुर सुधारि।\nबरनऊँ रघुबर बिमल जसु, जो दायक फल चारि॥",
//                               style: GoogleFonts.poppins(
//                                 color: Colors.white,
//                                 fontSize: screenWidth * 0.045,
//                                 height: 1.4,
//                               ),
//                               textAlign: TextAlign.start,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 10,
//                           left: 10,
//                           right: 10,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Slider(
//                                   min: 0,
//                                   max: _videoController.value.duration.inSeconds
//                                       .toDouble(),
//                                   value: _videoController
//                                       .value.position.inSeconds
//                                       .clamp(
//                                           0,
//                                           _videoController
//                                               .value.duration.inSeconds)
//                                       .toDouble(),
//                                   onChanged: (value) {
//                                     final seekTo =
//                                         Duration(seconds: value.toInt());
//                                     _videoController.seekTo(seekTo);
//                                   },
//                                   activeColor: Colors.purple,
//                                   inactiveColor: Colors.grey,
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: _toggleFullScreen,
//                                 child: Icon(
//                                   Icons.fullscreen,
//                                   size: 35,
//                                   color: AppConstants.purpleColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//             if (_showMenu) _buildMenu(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFullScreen(BuildContext context) {
//     final screenHeight = Get.height;
//     final screenWidth = Get.width;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onTap: () {
//           setState(() {
//             _showControls = !_showControls;
//             _showMenu = false;
//           });
//           if (!isPause) {
//             _startHideControlsTimer();
//           }
//         },
//         child: Stack(
//           children: [
//             Center(
//               child: isMusic
//                   ? Image.asset(
//                       "assets/icons/hanuman.png",
//                       fit: BoxFit.cover,
//                       height: screenHeight,
//                       width: screenWidth,
//                     )
//                   : _videoController.value.isInitialized
//                       ? AspectRatio(
//                           aspectRatio: 8 / 15.5,
//                           child: VideoPlayer(_videoController),
//                         )
//                       : Container(
//                           color: Colors.black,
//                           child:
//                               const Center(child: CircularProgressIndicator()),
//                         ),
//             ),
//             if (_showBackwardIcon)
//               const Center(
//                 child: FaIcon(FontAwesomeIcons.backward,
//                     size: 50, color: Colors.white),
//               ),
//             if (_showForwardIcon)
//               const Center(
//                 child: FaIcon(FontAwesomeIcons.forward,
//                     size: 50, color: Colors.white),
//               ),
//             if (_showControls)
//               Positioned(
//                 top: 30,
//                 left: 10,
//                 right: 10,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () => _showChapterDialog(context),
//                       child: Container(
//                         width: screenWidth * 0.42,
//                         height: screenHeight * 0.03,
//                         decoration: BoxDecoration(
//                           color: const Color.fromRGBO(30, 30, 30, 0.5),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         alignment: Alignment.center,
//                         child: Text(
//                           "2. Glory of Hanuman",
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white,
//                             fontSize: screenWidth * 0.035,
//                           ),
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: _toggleMenu,
//                       child: _iconBox("assets/icons/Vector (8).svg"),
//                     ),
//                   ],
//                 ),
//               ),
//             if (_showControls)
//               Positioned(
//                 bottom: Get.height * 0.45,
//                 left: 0,
//                 right: 0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: _backward,
//                       child: const FaIcon(
//                         FontAwesomeIcons.backwardStep,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                     SizedBox(width: Get.width * 0.2),
//                     GestureDetector(
//                       onTap: _togglePlayPause,
//                       child: FaIcon(
//                         isPause
//                             ? FontAwesomeIcons.play
//                             : FontAwesomeIcons.pause,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                     SizedBox(width: Get.width * 0.2),
//                     GestureDetector(
//                       onTap: _forward,
//                       child: const FaIcon(
//                         FontAwesomeIcons.forwardStep,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             Positioned(
//               bottom: 160,
//               left: 20,
//               right: 20,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   currentSubtitle.isNotEmpty
//                       ? currentSubtitle
//                       : "श्रीगुरु चरन सरोज रज, निज मनु मुकुर सुधारि।\nबरनऊँ रघुबर बिमल जसु, जो दायक फल चारि॥",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: screenWidth * 0.045,
//                     height: 1.4,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 40,
//               left: 20,
//               right: 20,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Slider(
//                       min: 0,
//                       max: _videoController.value.duration.inSeconds.toDouble(),
//                       value: _videoController.value.position.inSeconds
//                           .clamp(0, _videoController.value.duration.inSeconds)
//                           .toDouble(),
//                       onChanged: (value) {
//                         final seekTo = Duration(seconds: value.toInt());
//                         _videoController.seekTo(seekTo);
//                       },
//                       activeColor: Colors.purple,
//                       inactiveColor: Colors.grey,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: _toggleFullScreen,
//                     child: Icon(
//                       Icons.fullscreen_exit,
//                       size: 35,
//                       color: AppConstants.purpleColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (_showMenu) _buildMenu(context),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         _isFullScreen ? _buildFullScreen(context) : _buildNormalScreen(context),
//         if (!_isFullScreen || (_isFullScreen && _showControls))
//           Positioned(
//             left: Get.width * 0.5 - 22,
//             child: AnimatedContainer(
//               height: _isFullScreen ? Get.height * 1.58 : Get.height * 1.7,
//               duration: Duration(milliseconds: 300),
//               child: CircleAvatar(
//                 radius: 30,
//                 backgroundColor: AppConstants.purpleColor,
//                 child: const Center(
//                   child: FaIcon(
//                     FontAwesomeIcons.microphone,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _iconBox(dynamic svgPath) {
//     return Container(
//       height: Get.height * 0.030,
//       width: Get.width * 0.075,
//       padding: (svgPath == "assets/icons/Vector (7).svg")
//           ? EdgeInsets.all(Get.width * 0.017)
//           : (svgPath == "assets/icons/A.svg")
//               ? EdgeInsets.all(Get.width * 0.01)
//               : EdgeInsets.all(Get.width * 0.015),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(30, 30, 30, 0.4),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: SvgPicture.asset(
//         svgPath,
//         width: Get.width * 0.024,
//         height: Get.height * 0.016,
//       ),
//     );
//   }
// }

// class Subtitle {
//   final Duration start;
//   final Duration end;
//   final String text;

//   Subtitle(this.start, this.end, this.text);
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vedalaya_app/core/themes/app_constants.dart';
import 'package:vedalaya_app/views/learning/modules/chapter_selection.dart';
import 'package:vedalaya_app/views/learning/widgets/custom_progressbar.dart';
import 'package:vedalaya_app/views/learning/modules/language_selection.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart' show rootBundle;

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  bool isPause = true;
  bool isMusic = true;
  late VideoPlayerController _videoController;

  bool _showForwardIcon = false;
  bool _showBackwardIcon = false;
  bool _isFullScreen = false;
  bool _showControls = true;
  bool _showMenu = false;
  bool _isVideoEnded = false;
  bool _autoRepeat = false;

  double _playbackSpeed = 1.0;
  Timer? _hideControlsTimer;
  Timer? _endDialogTimer;

  List<Subtitle> subtitles = [];
  String currentSubtitle = "";
  int currentSubtitleIndex = -1;
  Timer? _subtitleTimer;

  final String videoUrl =
      'https://stream.mux.com/wlfOVYuv7OLpHOp17Hz75Kx00Vx6UeMf002k7uae01oo5k.m3u8';

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
      formatHint: VideoFormat.hls,
    )..initialize().then((_) {
        setState(() {});
        if (!isPause) _videoController.play();
      });

    _videoController.addListener(_videoListener);
    _loadSubtitles();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _isFullScreen ? _buildFullScreen(context) : _buildNormalScreen(context),
        if (!_isFullScreen || (_isFullScreen && _showControls))
          Positioned(
            left: Get.width * 0.5 - 22,
            child: AnimatedContainer(
              height: _isFullScreen ? Get.height * 1.58 : Get.height * 1.7,
              duration: Duration(milliseconds: 300),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: AppConstants.purpleColor,
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.microphone,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _loadSubtitles() async {
    try {
      final srtContent =
          await rootBundle.loadString('assets/icons/HanumanChalisa.srt');
      subtitles = parseSrt(srtContent);
      _startSubtitleUpdates();
    } catch (e) {
      print("Error loading subtitles: $e");
    }
  }

  List<Subtitle> parseSrt(String srtContent) {
    final subtitles = <Subtitle>[];
    final blocks = srtContent.split('\n\n');

    for (final block in blocks) {
      final lines = block.split('\n');
      if (lines.length >= 3) {
        final timeParts = lines[1].split(' --> ');
        if (timeParts.length == 2) {
          final startTime = _parseSrtTime(timeParts[0].trim());
          final endTime = _parseSrtTime(timeParts[1].trim());
          final text = lines.sublist(2).join('\n');
          subtitles.add(Subtitle(startTime, endTime, text));
        }
      }
    }

    return subtitles;
  }

  Duration _parseSrtTime(String timeString) {
    final parts = timeString.split(':');
    if (parts.length == 3) {
      final secondsParts = parts[2].split(',');
      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);
      final seconds = int.parse(secondsParts[0]);
      final milliseconds =
          secondsParts.length > 1 ? int.parse(secondsParts[1]) : 0;
      return Duration(
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
      );
    }
    return Duration.zero;
  }

  void _startSubtitleUpdates() {
    _subtitleTimer?.cancel();
    _subtitleTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_videoController.value.isInitialized || isPause) return;

      final currentPosition = _videoController.value.position;
      for (int i = 0; i < subtitles.length; i++) {
        if (currentPosition >= subtitles[i].start &&
            currentPosition <= subtitles[i].end) {
          if (i != currentSubtitleIndex) {
            setState(() {
              currentSubtitleIndex = i;
              currentSubtitle = subtitles[i].text;
            });
          }
          return;
        }
      }
      // If between subtitles
      setState(() {
        currentSubtitle = "";
      });
    });
  }

  int _findCurrentSubtitleIndex() {
    if (subtitles.isEmpty) return -1;
    final currentPosition = _videoController.value.position;

    for (int i = 0; i < subtitles.length; i++) {
      if (currentPosition >= subtitles[i].start &&
          currentPosition <= subtitles[i].end) {
        return i;
      }
    }

    // If between subtitles, find the next upcoming one
    for (int i = 0; i < subtitles.length; i++) {
      if (currentPosition < subtitles[i].start) {
        return i - 1; // Return previous subtitle index
      }
    }

    // If beyond all subtitles
    return subtitles.length - 1;
  }

  void _backward() {
    if (subtitles.isEmpty) return;

    final currentIndex = _findCurrentSubtitleIndex();
    int targetIndex;

    if (currentIndex <= 0) {
      // At or before first subtitle - go to start
      targetIndex = 0;
      _videoController.seekTo(Duration.zero);
    } else {
      // Go to previous subtitle
      targetIndex = currentIndex - 1;
      _videoController.seekTo(subtitles[targetIndex].start);
    }

    setState(() {
      currentSubtitleIndex = targetIndex;
      currentSubtitle = subtitles[targetIndex].text;
      _showBackwardIcon = true;
      _showControls = true;
      _showMenu = false;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _showBackwardIcon = false);
    });
    _startHideControlsTimer();
  }

  void _forward() {
    if (subtitles.isEmpty) return;

    final currentIndex = _findCurrentSubtitleIndex();
    int targetIndex;

    if (currentIndex >= subtitles.length - 1) {
      // At or after last subtitle - go to end
      _videoController.seekTo(_videoController.value.duration);
      return;
    } else {
      // Go to next subtitle
      targetIndex = currentIndex + 1;
      _videoController.seekTo(subtitles[targetIndex].start);
    }

    setState(() {
      currentSubtitleIndex = targetIndex;
      currentSubtitle = subtitles[targetIndex].text;
      _showForwardIcon = true;
      _showControls = true;
      _showMenu = false;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _showForwardIcon = false);
    });
    _startHideControlsTimer();
  }

  void _videoListener() {
    if (!_videoController.value.isInitialized) return;

    // Check if video reached the end
    if (_videoController.value.position >= _videoController.value.duration &&
        !_isVideoEnded &&
        _videoController.value.duration > Duration.zero) {
      setState(() {
        _isVideoEnded = true;
      });
      if (_autoRepeat) {
        _replayVideo();
      } else {
        // Show dialog when video ends
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showEndOfVideoDialog(context);
        });
      }
    } else if (_videoController.value.position <
        _videoController.value.duration) {
      _isVideoEnded = false;
    }

    if (mounted) setState(() {});
  }

  void _showEndOfVideoDialog(BuildContext context) {
    _endDialogTimer?.cancel();
    int countdown = 2;
    _endDialogTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      }
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Play Again in",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "00:0${_endDialogTimer != null ? 5 - (_endDialogTimer!.tick - 1) : 5}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.purpleColor,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.purpleColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      _endDialogTimer?.cancel();
                      Navigator.of(context, rootNavigator: true).pop();
                      _replayVideo();
                    },
                    child: const Text(
                      "Replay Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _replayVideo() {
    setState(() {
      _isVideoEnded = false;
    });
    _videoController
      ..seekTo(Duration.zero)
      ..play();
  }

  @override
  void dispose() {
    _videoController.removeListener(_videoListener);
    _videoController.dispose();
    _hideControlsTimer?.cancel();
    _endDialogTimer?.cancel();
    _subtitleTimer?.cancel();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _showMenu = !_showMenu;
      if (_showMenu) {
        _showControls = true;
        _hideControlsTimer?.cancel();
      }
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      _showMenu = false;
    });
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 2), () {
      if (mounted && !isPause) {
        setState(() {
          _showControls = false;
          _showMenu = false;
        });
      }
    });
  }

  Future<void> _togglePlayPause() async {
    setState(() {
      isPause = !isPause;
      _showMenu = false;
    });

    if (!isPause) {
      await _videoController.play();

      _startSubtitleUpdates();
      _startHideControlsTimer();
    } else {
      await _videoController.pause();
      _subtitleTimer?.cancel();
      _hideControlsTimer?.cancel();
    }

    setState(() {
      _showControls = true;
    });
  }

  void _toggleMode() {
    setState(() {
      isMusic = !isMusic;
      _showControls = true;
      _showMenu = false;
    });
    if (!isPause) {
      _startHideControlsTimer();
    }
  }

  void _showChapterDialog(BuildContext context) {
    setState(() {
      _showMenu = false;
    });
    showDialog(
      context: context,
      builder: (context) {
        return ChapterSelectionDialog(
          currentChapterIndex: 1,
          chapterCompletionStatus: [
            true,
            true,
            false,
            false,
            false,
            false,
            false
          ],
          chapterNames: [
            'Introduction',
            'Glory of Hanuman',
            'Chalisa Part 1',
            'Chalisa Part 2',
            'Chalisa Part 3',
            'Chalisa Part 4',
            'Chalisa Part 5',
          ],
        );
      },
    );
  }

  void _showSpeedSelector(BuildContext context) {
    setState(() {
      _showMenu = false;
    });
    final speeds = [0.5, 0.7, 1.0, 1.1, 1.2, 1.5];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Speed',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 12),
                ...speeds.map((speed) {
                  final isSelected = speed == _playbackSpeed;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _playbackSpeed = speed;
                      });
                      _videoController.setPlaybackSpeed(speed);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Color(0xFFD6B9F3) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${speed}x",
                        style: TextStyle(
                          color: isSelected ? Colors.purple : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 4),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenu(BuildContext context) {
    return Positioned(
      top: _isFullScreen ? 60 : 120,
      right: _isFullScreen ? 30 : 40,
      child: Container(
        padding: EdgeInsets.only(bottom: 5),
        width: Get.width * 0.55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Text(
                "Settings",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(height: 1, color: Colors.grey[300]),
            _buildMenuSection(
              title: "Subtitle",
              value: "Hindi",
              icon: "assets/icons/A.svg",
              onTap: () async {
                await showDialog<String>(
                  context: context,
                  builder: (context) => LanguageSelectionDialog(),
                );
              },
            ),
            _buildMenuSection(
              title: "Speed",
              value: "${_playbackSpeed}x",
              icon: "assets/icons/Vector (7).svg",
              onTap: () => _showSpeedSelector(context),
            ),
            _buildMenuSection(
              title: "Auto Repeat",
              value: "",
              icon: "assets/icons/Vector (9).svg",
              isToggle: true,
              toggleValue: _autoRepeat,
              onTap: () {
                setState(() {
                  _autoRepeat = !_autoRepeat;
                });
              },
            ),
            _buildMenuSection(
              title: isMusic ? "Video" : "Audio",
              value: "",
              icon:
                  isMusic ? "assets/icons/video.svg" : "assets/icons/music.svg",
              onTap: _toggleMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required String value,
    required String icon,
    bool isToggle = false,
    bool toggleValue = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // SvgPicture.asset(icon, color: Colors.grey[700]),
                _iconBox(icon),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(30, 30, 30, 1)),
                ),
              ],
            ),
            if (value.isNotEmpty)
              Row(
                children: [
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Color.fromRGBO(30, 30, 30, 0.9)),
                  ),
                  Icon(Icons.keyboard_arrow_right_outlined)
                ],
              ),
            if (isToggle)
              Transform.scale(
                scale: 0.6,
                child: Switch(
                  value: toggleValue,
                  onChanged: (val) => onTap(),
                  activeColor: AppConstants.purpleColor,
                ),
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildNormalScreen(BuildContext context) {
    final screenHeight = Get.height;
    final screenWidth = Get.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9EE),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Icon(Icons.keyboard_arrow_left, size: 30),
                    SizedBox(width: screenWidth * 0.22),
                    Text("Hanuman Chalisa",
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF3A0084),
                        )),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    CustomProgressBar(progress: 4 / 9),
                    const SizedBox(height: 4),
                    Text("2/9 Lessons Completed",
                        style:
                            GoogleFonts.poppins(fontSize: screenWidth * 0.035)),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: screenHeight * 0.66,
                  width: screenWidth * 0.9,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showControls = !_showControls;
                        _showMenu = false;
                      });
                      if (!isPause) {
                        _startHideControlsTimer();
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: isMusic
                              ? Image.asset(
                                  "assets/icons/hanuman.png",
                                  fit: BoxFit.cover,
                                  height: screenHeight * 0.66,
                                  width: screenWidth * 0.9,
                                )
                              : _videoController.value.isInitialized
                                  ? FittedBox(
                                      fit: BoxFit.cover,
                                      child: SizedBox(
                                        height: screenHeight * 0.66,
                                        width: screenWidth * 0.9,
                                        child: VideoPlayer(_videoController),
                                      ),
                                    )
                                  : Container(
                                      color: Colors.grey,
                                      height: screenHeight * 0.66,
                                      width: screenWidth * 0.9,
                                      child: const Center(
                                          child: CircularProgressIndicator()),
                                    ),
                        ),
                        if (_showBackwardIcon)
                          const FaIcon(FontAwesomeIcons.backward,
                              size: 50, color: Colors.white),
                        if (_showForwardIcon)
                          const FaIcon(FontAwesomeIcons.forward,
                              size: 50, color: Colors.white),
                        if (_showControls)
                          Positioned(
                            top: 12,
                            left: 10,
                            right: 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => _showChapterDialog(context),
                                  child: Container(
                                    width: screenWidth * 0.42,
                                    height: screenHeight * 0.03,
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(30, 30, 30, 0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text("2. Glory of Hanuman",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: screenWidth * 0.035,
                                        )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _toggleMenu,
                                  child:
                                      _iconBox("assets/icons/Vector (8).svg"),
                                ),
                              ],
                            ),
                          ),
                        if (_showControls)
                          Positioned(
                            top: screenHeight * 0.33,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: _backward,
                                  child: const FaIcon(
                                    FontAwesomeIcons.backwardStep,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 50),
                                GestureDetector(
                                  onTap: _togglePlayPause,
                                  child: FaIcon(
                                    isPause
                                        ? FontAwesomeIcons.play
                                        : FontAwesomeIcons.pause,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 50),
                                GestureDetector(
                                  onTap: _forward,
                                  child: const FaIcon(
                                    FontAwesomeIcons.forwardStep,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Positioned(
                          bottom: 70,
                          left: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              currentSubtitle.isNotEmpty
                                  ? currentSubtitle
                                  : "श्रीगुरु चरन सरोज रज, निज मनु मुकुर सुधारि।\nबरनऊँ रघुबर बिमल जसु, जो दायक फल चारि॥",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: screenWidth * 0.045,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Row(
                            children: [
                              Expanded(
                                child: Slider(
                                  min: 0,
                                  max: _videoController.value.duration.inSeconds
                                      .toDouble(),
                                  value: _videoController
                                      .value.position.inSeconds
                                      .clamp(
                                          0,
                                          _videoController
                                              .value.duration.inSeconds)
                                      .toDouble(),
                                  onChanged: (value) {
                                    final seekTo =
                                        Duration(seconds: value.toInt());
                                    _videoController.seekTo(seekTo);
                                  },
                                  activeColor: Colors.purple,
                                  inactiveColor: Colors.grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: _toggleFullScreen,
                                child: Icon(
                                  Icons.fullscreen,
                                  size: 35,
                                  color: AppConstants.purpleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            if (_showMenu) _buildMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreen(BuildContext context) {
    final screenHeight = Get.height;
    final screenWidth = Get.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
            _showMenu = false;
          });
          if (!isPause) {
            _startHideControlsTimer();
          }
        },
        child: Stack(
          children: [
            Center(
              child: isMusic
                  ? Image.asset(
                      "assets/icons/hanuman.png",
                      fit: BoxFit.cover,
                      height: screenHeight,
                      width: screenWidth,
                    )
                  : _videoController.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: 8 / 15.5,
                          child: VideoPlayer(_videoController),
                        )
                      : Container(
                          color: Colors.black,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
            ),
            if (_showBackwardIcon)
              const Center(
                child: FaIcon(FontAwesomeIcons.backward,
                    size: 50, color: Colors.white),
              ),
            if (_showForwardIcon)
              const Center(
                child: FaIcon(FontAwesomeIcons.forward,
                    size: 50, color: Colors.white),
              ),
            if (_showControls)
              Positioned(
                top: 30,
                left: 10,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => _showChapterDialog(context),
                      child: Container(
                        width: screenWidth * 0.42,
                        height: screenHeight * 0.03,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(30, 30, 30, 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "2. Glory of Hanuman",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _toggleMenu,
                      child: _iconBox("assets/icons/Vector (8).svg"),
                    ),
                  ],
                ),
              ),
            if (_showControls)
              Positioned(
                bottom: Get.height * 0.45,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _backward,
                      child: const FaIcon(
                        FontAwesomeIcons.backwardStep,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(width: Get.width * 0.2),
                    GestureDetector(
                      onTap: _togglePlayPause,
                      child: FaIcon(
                        isPause
                            ? FontAwesomeIcons.play
                            : FontAwesomeIcons.pause,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(width: Get.width * 0.2),
                    GestureDetector(
                      onTap: _forward,
                      child: const FaIcon(
                        FontAwesomeIcons.forwardStep,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            Positioned(
              bottom: 160,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  currentSubtitle.isNotEmpty
                      ? currentSubtitle
                      : "श्रीगुरु चरन सरोज रज, निज मनु मुकुर सुधारि।\nबरनऊँ रघुबर बिमल जसु, जो दायक फल चारि॥",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: screenWidth * 0.045,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  Expanded(
                    child: Slider(
                      min: 0,
                      max: _videoController.value.duration.inSeconds.toDouble(),
                      value: _videoController.value.position.inSeconds
                          .clamp(0, _videoController.value.duration.inSeconds)
                          .toDouble(),
                      onChanged: (value) {
                        final seekTo = Duration(seconds: value.toInt());
                        _videoController.seekTo(seekTo);
                      },
                      activeColor: Colors.purple,
                      inactiveColor: Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: _toggleFullScreen,
                    child: Icon(
                      Icons.fullscreen_exit,
                      size: 35,
                      color: AppConstants.purpleColor,
                    ),
                  ),
                ],
              ),
            ),
            if (_showMenu) _buildMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _iconBox(dynamic svgPath) {
    return Container(
      height: Get.height * 0.030,
      width: Get.width * 0.075,
      padding: (svgPath == "assets/icons/Vector (7).svg")
          ? EdgeInsets.all(Get.width * 0.017)
          : (svgPath == "assets/icons/A.svg")
              ? EdgeInsets.all(Get.width * 0.01)
              : EdgeInsets.all(Get.width * 0.015),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(30, 30, 30, 0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SvgPicture.asset(
        svgPath,
        width: Get.width * 0.024,
        height: Get.height * 0.016,
      ),
    );
  }
}

class Subtitle {
  final Duration start;
  final Duration end;
  final String text;

  Subtitle(this.start, this.end, this.text);
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:vedalaya_app/core/themes/app_constants.dart';
// import 'package:vedalaya_app/view/learning/modules/chapter_selection.dart';
// import 'package:vedalaya_app/view/learning/modules/custom_progressbar.dart';
// import 'package:vedalaya_app/view/learning/modules/language_selection.dart';
// import 'package:better_player/better_player.dart';
// import 'package:flutter/services.dart' show rootBundle;

// class LearningScreen extends StatefulWidget {
//   const LearningScreen({super.key});

//   @override
//   State<LearningScreen> createState() => _LearningScreenState();
// }

// class _LearningScreenState extends State<LearningScreen> {
//   bool isPause = true;
//   bool isMusic = true;
//   late BetterPlayerController _betterPlayerController;

//   bool _showForwardIcon = false;
//   bool _showBackwardIcon = false;
//   bool _isFullScreen = false;
//   bool _showControls = true;
//   bool _showMenu = false;
//   bool _isVideoEnded = false;

//   double _playbackSpeed = 1.0;
//   Timer? _hideControlsTimer;
//   Timer? _endDialogTimer;

//   List<Subtitle> subtitles = [];
//   String currentSubtitle = "";
//   int currentSubtitleIndex = -1;
//   Timer? _subtitleTimer;

//   final String videoUrl =
//       'https://stream.mux.com/wlfOVYuv7OLpHOp17Hz75Kx00Vx6UeMf002k7uae01oo5k.m3u8';

//   @override
//   void initState() {
//     super.initState();
//     _initializeBetterPlayer();
//     _loadSubtitles();
//   }

//   void _initializeBetterPlayer() {
//     BetterPlayerConfiguration betterPlayerConfiguration =
//         BetterPlayerConfiguration(
//       aspectRatio: 16 / 9,
//       fit: BoxFit.contain,
//       controlsConfiguration: BetterPlayerControlsConfiguration(
//         showControls: false,
//         enableSkips: false,
//         enableFullscreen: false,
//       ),
//       autoPlay: !isPause,
//       looping: false,
//     );

//     BetterPlayerDataSource dataSource = BetterPlayerDataSource(
//       BetterPlayerDataSourceType.network,
//       videoUrl,
//     );

//     _betterPlayerController = BetterPlayerController(
//       betterPlayerConfiguration,
//       betterPlayerDataSource: dataSource,
//     );

//     _betterPlayerController.addEventsListener((event) {
//       if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
//         _videoListener();
//       } else if (event.betterPlayerEventType ==
//           BetterPlayerEventType.finished) {
//         setState(() {
//           _isVideoEnded = true;
//         });
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _showEndOfVideoDialog(context);
//         });
//       } else if (event.betterPlayerEventType ==
//           BetterPlayerEventType.initialized) {
//         setState(() {});
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         _isFullScreen ? _buildFullScreen(context) : _buildNormalScreen(context),
//         if (!_isFullScreen || (_isFullScreen && _showControls))
//           Positioned(
//             left: Get.width * 0.5 - 22,
//             child: AnimatedContainer(
//               height: _isFullScreen ? Get.height * 1.58 : Get.height * 1.7,
//               duration: Duration(milliseconds: 300),
//               child: CircleAvatar(
//                 radius: 30,
//                 backgroundColor: AppConstants.purpleColor,
//                 child: const Center(
//                   child: FaIcon(
//                     FontAwesomeIcons.microphone,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Future<void> _loadSubtitles() async {
//     try {
//       final srtContent =
//           await rootBundle.loadString('assets/icons/HanumanChalisa.srt');
//       subtitles = parseSrt(srtContent);
//       _startSubtitleUpdates();
//     } catch (e) {
//       print("Error loading subtitles: $e");
//     }
//   }

//   List<Subtitle> parseSrt(String srtContent) {
//     final subtitles = <Subtitle>[];
//     final blocks = srtContent.split('\n\n');

//     for (final block in blocks) {
//       final lines = block.split('\n');
//       if (lines.length >= 3) {
//         final timeParts = lines[1].split(' --> ');
//         if (timeParts.length == 2) {
//           final startTime = _parseSrtTime(timeParts[0].trim());
//           final endTime = _parseSrtTime(timeParts[1].trim());
//           final text = lines.sublist(2).join('\n');
//           subtitles.add(Subtitle(startTime, endTime, text));
//         }
//       }
//     }

//     return subtitles;
//   }

//   Duration _parseSrtTime(String timeString) {
//     final parts = timeString.split(':');
//     if (parts.length == 3) {
//       final secondsParts = parts[2].split(',');
//       final hours = int.parse(parts[0]);
//       final minutes = int.parse(parts[1]);
//       final seconds = int.parse(secondsParts[0]);
//       final milliseconds =
//           secondsParts.length > 1 ? int.parse(secondsParts[1]) : 0;
//       return Duration(
//         hours: hours,
//         minutes: minutes,
//         seconds: seconds,
//         milliseconds: milliseconds,
//       );
//     }
//     return Duration.zero;
//   }

//   void _startSubtitleUpdates() {
//     _subtitleTimer?.cancel();
//     _subtitleTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (!(_betterPlayerController.isVideoInitialized() ?? true) || isPause)
//         return;

//       final currentPosition =
//           _betterPlayerController.videoPlayerController?.value.position ??
//               Duration.zero;
//       for (int i = 0; i < subtitles.length; i++) {
//         if (currentPosition >= subtitles[i].start &&
//             currentPosition <= subtitles[i].end) {
//           if (i != currentSubtitleIndex) {
//             setState(() {
//               currentSubtitleIndex = i;
//               currentSubtitle = subtitles[i].text;
//             });
//           }
//           return;
//         }
//       }
//       // If between subtitles
//       setState(() {
//         currentSubtitle = "";
//       });
//     });
//   }

//   int _findCurrentSubtitleIndex() {
//     if (subtitles.isEmpty) return -1;
//     final currentPosition =
//         _betterPlayerController.videoPlayerController?.value.position ??
//             Duration.zero;

//     for (int i = 0; i < subtitles.length; i++) {
//       if (currentPosition >= subtitles[i].start &&
//           currentPosition <= subtitles[i].end) {
//         return i;
//       }
//     }

//     // If between subtitles, find the next upcoming one
//     for (int i = 0; i < subtitles.length; i++) {
//       if (currentPosition < subtitles[i].start) {
//         return i - 1; // Return previous subtitle index
//       }
//     }

//     // If beyond all subtitles
//     return subtitles.length - 1;
//   }

//   void _backward() {
//     if (subtitles.isEmpty) return;

//     final currentIndex = _findCurrentSubtitleIndex();
//     int targetIndex;

//     if (currentIndex <= 0) {
//       // At or before first subtitle - go to start
//       targetIndex = 0;
//       _betterPlayerController.seekTo(Duration.zero);
//     } else {
//       // Go to previous subtitle
//       targetIndex = currentIndex - 1;
//       _betterPlayerController.seekTo(subtitles[targetIndex].start);
//     }

//     setState(() {
//       currentSubtitleIndex = targetIndex;
//       currentSubtitle = subtitles[targetIndex].text;
//       _showBackwardIcon = true;
//       _showControls = true;
//       _showMenu = false;
//     });

//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (mounted) setState(() => _showBackwardIcon = false);
//     });
//     _startHideControlsTimer();
//   }

//   void _forward() {
//     if (subtitles.isEmpty) return;

//     final currentIndex = _findCurrentSubtitleIndex();
//     int targetIndex;

//     if (currentIndex >= subtitles.length - 1) {
//       // At or after last subtitle - go to end
//       _betterPlayerController.seekTo(
//           _betterPlayerController.videoPlayerController?.value.duration ??
//               Duration.zero);
//       return;
//     } else {
//       // Go to next subtitle
//       targetIndex = currentIndex + 1;
//       _betterPlayerController.seekTo(subtitles[targetIndex].start);
//     }

//     setState(() {
//       currentSubtitleIndex = targetIndex;
//       currentSubtitle = subtitles[targetIndex].text;
//       _showForwardIcon = true;
//       _showControls = true;
//       _showMenu = false;
//     });

//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (mounted) setState(() => _showForwardIcon = false);
//     });
//     _startHideControlsTimer();
//   }

//   void _videoListener() {
//     if (!(_betterPlayerController.isVideoInitialized() ?? true)) return;

//     // Check if video reached the end
//     final duration =
//         _betterPlayerController.videoPlayerController?.value.duration ??
//             Duration.zero;
//     final position =
//         _betterPlayerController.videoPlayerController?.value.position ??
//             Duration.zero;

//     if (position >= duration && !_isVideoEnded && duration > Duration.zero) {
//       setState(() {
//         _isVideoEnded = true;
//       });
//       // Show dialog when video ends
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _showEndOfVideoDialog(context);
//       });
//     } else if (position < duration) {
//       _isVideoEnded = false;
//     }

//     if (mounted) setState(() {});
//   }

//   void _showEndOfVideoDialog(BuildContext context) {
//     _endDialogTimer?.cancel();
//     int countdown = 2;
//     _endDialogTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (countdown > 0) {
//         setState(() {
//           countdown--;
//         });
//       } else {
//         timer.cancel();
//         if (mounted && Navigator.of(context).canPop()) {
//           Navigator.of(context, rootNavigator: true).pop();
//         }
//       }
//     });

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16.0),
//           ),
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Play Again in",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey[800],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   "00:0${_endDialogTimer != null ? 5 - (_endDialogTimer!.tick - 1) : 5}",
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: AppConstants.purpleColor,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppConstants.purpleColor,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     onPressed: () {
//                       _endDialogTimer?.cancel();
//                       Navigator.of(context, rootNavigator: true).pop();
//                       _replayVideo();
//                     },
//                     child: const Text(
//                       "Replay Now",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _replayVideo() {
//     setState(() {
//       _isVideoEnded = false;
//     });
//     _betterPlayerController
//       ..seekTo(Duration.zero)
//       ..play();
//   }

//   @override
//   void dispose() {
//     _betterPlayerController.dispose();
//     _hideControlsTimer?.cancel();
//     _endDialogTimer?.cancel();
//     _subtitleTimer?.cancel();
//     super.dispose();
//   }

//   void _toggleMenu() {
//     setState(() {
//       _showMenu = !_showMenu;
//       if (_showMenu) {
//         _showControls = true;
//         _hideControlsTimer?.cancel();
//       }
//     });
//   }

//   void _toggleFullScreen() {
//     setState(() {
//       _isFullScreen = !_isFullScreen;
//       _showMenu = false;
//     });
//   }

//   void _startHideControlsTimer() {
//     _hideControlsTimer?.cancel();
//     _hideControlsTimer = Timer(const Duration(seconds: 2), () {
//       if (mounted && !isPause) {
//         setState(() {
//           _showControls = false;
//           _showMenu = false;
//         });
//       }
//     });
//   }

//   Future<void> _togglePlayPause() async {
//     setState(() {
//       isPause = !isPause;
//       _showMenu = false;
//     });

//     if (!isPause) {
//       await _betterPlayerController.play();

//       _startSubtitleUpdates();
//       _startHideControlsTimer();
//     } else {
//       await _betterPlayerController.pause();
//       _subtitleTimer?.cancel();
//       _hideControlsTimer?.cancel();
//     }

//     setState(() {
//       _showControls = true;
//     });
//   }

//   void _toggleMode() {
//     setState(() {
//       isMusic = !isMusic;
//       _showControls = true;
//       _showMenu = false;
//     });
//     if (!isPause) {
//       _startHideControlsTimer();
//     }
//   }

//   void _showChapterDialog(BuildContext context) {
//     setState(() {
//       _showMenu = false;
//     });
//     showDialog(
//       context: context,
//       builder: (context) {
//         return ChapterSelectionDialog(
//           currentChapterIndex: 1,
//           chapterCompletionStatus: [
//             true,
//             true,
//             false,
//             false,
//             false,
//             false,
//             false
//           ],
//           chapterNames: [
//             'Introduction',
//             'Glory of Hanuman',
//             'Chalisa Part 1',
//             'Chalisa Part 2',
//             'Chalisa Part 3',
//             'Chalisa Part 4',
//             'Chalisa Part 5',
//           ],
//         );
//       },
//     );
//   }

//   void _showSpeedSelector(BuildContext context) {
//     setState(() {
//       _showMenu = false;
//     });
//     final speeds = [0.5, 0.7, 1.0, 1.1, 1.2, 1.5];

//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           backgroundColor: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Select Speed',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: Colors.purple,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 ...speeds.map((speed) {
//                   final isSelected = speed == _playbackSpeed;
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _playbackSpeed = speed;
//                       });
//                       _betterPlayerController.setSpeed(speed);
//                       Navigator.of(context).pop();
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 12, horizontal: 10),
//                       margin: const EdgeInsets.symmetric(vertical: 2),
//                       decoration: BoxDecoration(
//                         color:
//                             isSelected ? Color(0xFFD6B9F3) : Colors.transparent,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         "${speed}x",
//                         style: TextStyle(
//                           color: isSelected ? Colors.purple : Colors.black,
//                           fontWeight:
//                               isSelected ? FontWeight.bold : FontWeight.normal,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//                 const SizedBox(height: 4),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildMenu(BuildContext context) {
//     return Positioned(
//       top: _isFullScreen ? 60 : 120,
//       right: _isFullScreen ? 30 : 40,
//       child: Container(
//         width: Get.width * 0.5,
//         decoration: BoxDecoration(
//           color: _isFullScreen ? Colors.white : Colors.white70,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildMenuSection(
//               items: [
//                 _buildMenuItem(
//                   icon: "assets/icons/A.svg",
//                   text: "Subtitle",
//                   onTap: () {
//                     LanguageSelectionDialog();
//                   },
//                 ),
//                 _buildMenuItem(
//                   icon: "assets/icons/Vector (7).svg",
//                   text: "Speed",
//                   onTap: () => _showSpeedSelector(context),
//                 ),
//                 _buildMenuItem(
//                   icon: (isMusic)
//                       ? "assets/icons/video.svg"
//                       : "assets/icons/music.svg",
//                   text: (isMusic) ? "Video" : "Audio",
//                   onTap: () {
//                     _toggleMode();
//                   },
//                 ),
//                 _buildMenuItem(
//                   icon: "assets/icons/Vector (9).svg",
//                   text: "Auto Repeat",
//                   onTap: () {
//                     _replayVideo();
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuSection({required List<Widget> items}) {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 8),
//           ...items,
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuItem({
//     required String icon,
//     required String text,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: Row(
//           children: [
//             _iconBox(icon),
//             const SizedBox(width: 12),
//             Text(
//               text,
//               style: GoogleFonts.poppins(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[800],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNormalScreen(BuildContext context) {
//     final screenHeight = Get.height;
//     final screenWidth = Get.width;

//     return Scaffold(
//       backgroundColor: const Color(0xFFFCF9EE),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(Icons.keyboard_arrow_left, size: 30),
//                     SizedBox(width: screenWidth * 0.22),
//                     Text("Hanuman Chalisa",
//                         style: GoogleFonts.poppins(
//                           fontSize: screenWidth * 0.045,
//                           fontWeight: FontWeight.w700,
//                           color: const Color(0xFF3A0084),
//                         )),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Column(
//                   children: [
//                     CustomProgressBar(progress: 4 / 9),
//                     const SizedBox(height: 4),
//                     Text("2/9 Lessons Completed",
//                         style:
//                             GoogleFonts.poppins(fontSize: screenWidth * 0.035)),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 SizedBox(
//                   height: screenHeight * 0.66,
//                   width: screenWidth * 0.9,
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _showControls = !_showControls;
//                         _showMenu = false;
//                       });
//                       if (!isPause) {
//                         _startHideControlsTimer();
//                       }
//                     },
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: isMusic
//                               ? Image.asset(
//                                   "assets/icons/hanuman.png",
//                                   fit: BoxFit.cover,
//                                   height: screenHeight * 0.66,
//                                   width: screenWidth * 0.9,
//                                 )
//                               : (_betterPlayerController.isVideoInitialized() ??
//                                       false)
//                                   ? FittedBox(
//                                       fit: BoxFit.cover,
//                                       child: SizedBox(
//                                         height: screenHeight * 0.66,
//                                         width: screenWidth * 0.9,
//                                         child: BetterPlayer(
//                                           controller: _betterPlayerController,
//                                         ),
//                                       ),
//                                     )
//                                   : Container(
//                                       color: Colors.grey,
//                                       height: screenHeight * 0.66,
//                                       width: screenWidth * 0.9,
//                                       child: const Center(
//                                           child: CircularProgressIndicator()),
//                                     ),
//                         ),
//                         if (_showBackwardIcon)
//                           const FaIcon(FontAwesomeIcons.backward,
//                               size: 50, color: Colors.white),
//                         if (_showForwardIcon)
//                           const FaIcon(FontAwesomeIcons.forward,
//                               size: 50, color: Colors.white),
//                         if (_showControls)
//                           Positioned(
//                             top: 12,
//                             left: 10,
//                             right: 10,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 GestureDetector(
//                                   onTap: () => _showChapterDialog(context),
//                                   child: Container(
//                                     width: screenWidth * 0.42,
//                                     height: screenHeight * 0.03,
//                                     decoration: BoxDecoration(
//                                       color:
//                                           const Color.fromRGBO(30, 30, 30, 0.5),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     alignment: Alignment.center,
//                                     child: Text("2. Glory of Hanuman",
//                                         style: GoogleFonts.poppins(
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                           fontSize: screenWidth * 0.035,
//                                         )),
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: _toggleMenu,
//                                   child:
//                                       _iconBox("assets/icons/Vector (8).svg"),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         if (_showControls)
//                           Positioned(
//                             top: screenHeight * 0.33,
//                             child: Row(
//                               children: [
//                                 GestureDetector(
//                                   onTap: _backward,
//                                   child: const FaIcon(
//                                     FontAwesomeIcons.backwardStep,
//                                     color: Colors.white,
//                                     size: 30,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 50),
//                                 GestureDetector(
//                                   onTap: _togglePlayPause,
//                                   child: FaIcon(
//                                     isPause
//                                         ? FontAwesomeIcons.play
//                                         : FontAwesomeIcons.pause,
//                                     color: Colors.white,
//                                     size: 30,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 50),
//                                 GestureDetector(
//                                   onTap: _forward,
//                                   child: const FaIcon(
//                                     FontAwesomeIcons.forwardStep,
//                                     color: Colors.white,
//                                     size: 30,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         Positioned(
//                           bottom: 70,
//                           left: 20,
//                           right: 20,
//                           child: Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.5),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               currentSubtitle.isNotEmpty
//                                   ? currentSubtitle
//                                   : "श्रीगुरु चरन सरोज रज, निज मनु मुकुर सुधारि।\nबरनऊँ रघुबर बिमल जसु, जो दायक फल चारि॥",
//                               style: GoogleFonts.poppins(
//                                 color: Colors.white,
//                                 fontSize: screenWidth * 0.045,
//                                 height: 1.4,
//                               ),
//                               textAlign: TextAlign.start,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 10,
//                           left: 10,
//                           right: 10,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: Slider(
//                                   min: 0,
//                                   max: _betterPlayerController
//                                           .videoPlayerController
//                                           ?.value
//                                           .duration!
//                                           .inSeconds
//                                           .toDouble() ??
//                                       0,
//                                   value: _betterPlayerController
//                                           .videoPlayerController
//                                           ?.value
//                                           .position
//                                           .inSeconds
//                                           .toDouble()
//                                           .clamp(
//                                               0,
//                                               _betterPlayerController
//                                                       .videoPlayerController
//                                                       ?.value
//                                                       .duration!
//                                                       .inSeconds
//                                                       .toDouble() ??
//                                                   0) ??
//                                       0,
//                                   onChanged: (value) {
//                                     final seekTo =
//                                         Duration(seconds: value.toInt());
//                                     _betterPlayerController.seekTo(seekTo);
//                                   },
//                                   activeColor: Colors.purple,
//                                   inactiveColor: Colors.grey,
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: _toggleFullScreen,
//                                 child: Icon(
//                                   Icons.fullscreen,
//                                   size: 35,
//                                   color: AppConstants.purpleColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//             if (_showMenu) _buildMenu(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFullScreen(BuildContext context) {
//     final screenHeight = Get.height;
//     final screenWidth = Get.width;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: GestureDetector(
//         onTap: () {
//           setState(() {
//             _showControls = !_showControls;
//             _showMenu = false;
//           });
//           if (!isPause) {
//             _startHideControlsTimer();
//           }
//         },
//         child: Stack(
//           children: [
//             Center(
//               child: isMusic
//                   ? Image.asset(
//                       "assets/icons/hanuman.png",
//                       fit: BoxFit.cover,
//                       height: screenHeight,
//                       width: screenWidth,
//                     )
//                   : (_betterPlayerController.isVideoInitialized() ?? false)
//                       ? AspectRatio(
//                           aspectRatio: 8 / 15.5,
//                           child: BetterPlayer(
//                             controller: _betterPlayerController,
//                           ),
//                         )
//                       : Container(
//                           color: Colors.black,
//                           child:
//                               const Center(child: CircularProgressIndicator()),
//                         ),
//             ),
//             if (_showBackwardIcon)
//               const Center(
//                 child: FaIcon(FontAwesomeIcons.backward,
//                     size: 50, color: Colors.white),
//               ),
//             if (_showForwardIcon)
//               const Center(
//                 child: FaIcon(FontAwesomeIcons.forward,
//                     size: 50, color: Colors.white),
//               ),
//             if (_showControls)
//               Positioned(
//                 top: 30,
//                 left: 10,
//                 right: 10,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       onTap: () => _showChapterDialog(context),
//                       child: Container(
//                         width: screenWidth * 0.42,
//                         height: screenHeight * 0.03,
//                         decoration: BoxDecoration(
//                           color: const Color.fromRGBO(30, 30, 30, 0.5),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         alignment: Alignment.center,
//                         child: Text(
//                           "2. Glory of Hanuman",
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.white,
//                             fontSize: screenWidth * 0.035,
//                           ),
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: _toggleMenu,
//                       child: _iconBox("assets/icons/Vector (8).svg"),
//                     ),
//                   ],
//                 ),
//               ),
//             if (_showControls)
//               Positioned(
//                 bottom: Get.height * 0.45,
//                 left: 0,
//                 right: 0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: _backward,
//                       child: const FaIcon(
//                         FontAwesomeIcons.backwardStep,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                     SizedBox(width: Get.width * 0.2),
//                     GestureDetector(
//                       onTap: _togglePlayPause,
//                       child: FaIcon(
//                         isPause
//                             ? FontAwesomeIcons.play
//                             : FontAwesomeIcons.pause,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                     SizedBox(width: Get.width * 0.2),
//                     GestureDetector(
//                       onTap: _forward,
//                       child: const FaIcon(
//                         FontAwesomeIcons.forwardStep,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             Positioned(
//               bottom: 160,
//               left: 20,
//               right: 20,
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.5),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   currentSubtitle.isNotEmpty
//                       ? currentSubtitle
//                       : "श्रीगुरु चरन सरोज रज, निज मनु मुकुर सुधारि।\nबरनऊँ रघुबर बिमल जसु, जो दायक फल चारि॥",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: screenWidth * 0.045,
//                     height: 1.4,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 40,
//               left: 20,
//               right: 20,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Slider(
//                       min: 0,
//                       max: _betterPlayerController
//                               .videoPlayerController?.value.duration!.inSeconds
//                               .toDouble() ??
//                           0,
//                       value: _betterPlayerController
//                               .videoPlayerController?.value.position.inSeconds
//                               .toDouble()
//                               .clamp(
//                                   0,
//                                   _betterPlayerController.videoPlayerController
//                                           ?.value.duration!.inSeconds
//                                           .toDouble() ??
//                                       0) ??
//                           0,
//                       onChanged: (value) {
//                         final seekTo = Duration(seconds: value.toInt());
//                         _betterPlayerController.seekTo(seekTo);
//                       },
//                       activeColor: Colors.purple,
//                       inactiveColor: Colors.grey,
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: _toggleFullScreen,
//                     child: Icon(
//                       Icons.fullscreen_exit,
//                       size: 35,
//                       color: AppConstants.purpleColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (_showMenu) _buildMenu(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _iconBox(dynamic svgPath) {
//     return Container(
//       height: Get.height * 0.030,
//       width: Get.width * 0.075,
//       padding: (svgPath == "assets/icons/Vector (7).svg")
//           ? EdgeInsets.all(Get.width * 0.017)
//           : (svgPath == "assets/icons/A.svg")
//               ? EdgeInsets.all(Get.width * 0.01)
//               : EdgeInsets.all(Get.width * 0.015),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(30, 30, 30, 0.4),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: SvgPicture.asset(
//         svgPath,
//         width: Get.width * 0.024,
//         height: Get.height * 0.016,
//       ),
//     );
//   }
// }

// class Subtitle {
//   final Duration start;
//   final Duration end;
//   final String text;

//   Subtitle(this.start, this.end, this.text);
// }
