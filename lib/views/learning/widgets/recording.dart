// import 'dart:io';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:vedalaya_app/core/themes/app_constants.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// // import 'package:just_audio_waveforms/just_audio_waveforms.dart';

// class MicrophoneBottomSheet extends StatefulWidget {
//   const MicrophoneBottomSheet({super.key});

//   @override
//   State<MicrophoneBottomSheet> createState() => _MicrophoneBottomSheetState();
// }

// class _MicrophoneBottomSheetState extends State<MicrophoneBottomSheet> {
//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   bool _isRecording = false;
//   String _recordFilePath = '';
//   Duration _recordDuration = Duration.zero;
//   Timer? _timer;
//   // late WaveformController waveformController;

//   @override
//   void initState() {
//     super.initState();
//     // waveformController = WaveformController();
//     _initRecorder();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _recorder.closeRecorder();
//     // waveformController.dispose();
//     super.dispose();
//   }

//   Future<void> _initRecorder() async {
//     await _recorder.openRecorder();
//     _recorder.setSubscriptionDuration(const Duration(milliseconds: 50));
//   }

//   Future<void> _startRecording() async {
//     try {
//       if (await Permission.microphone.request().isGranted) {
//         final directory = await getTemporaryDirectory();
//         final filePath = '${directory.path}/recording.aac';

//         await _recorder.startRecorder(
//           toFile: filePath,
//           codec: Codec.aacADTS,
//         );

//         setState(() {
//           _isRecording = true;
//           _recordFilePath = filePath;
//           _recordDuration = Duration.zero;
//         });

//         // Initialize waveform controller
//         // waveformController.prepare(
//         //   path: filePath,
//         //   shouldExtractWaveform: true,
//         //   noOfSamples: 100,
//         // );

//         _startTimer();
//       }
//     } catch (e) {
//       debugPrint('Error starting recording: $e');
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       await _recorder.stopRecorder();
//       _timer?.cancel();

//       setState(() {
//         _isRecording = false;
//       });

//       debugPrint('Recording saved to: $_recordFilePath');
//     } catch (e) {
//       debugPrint('Error stopping recording: $e');
//     }
//   }

//   void _startTimer() {
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         _recordDuration = Duration(seconds: _recordDuration.inSeconds + 1);
//       });
//     });
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$minutes:$seconds';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(217, 217, 217, 1),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SizedBox(
//                 height: Get.height * 0.1,
//                 width: Get.width * 0.25,
//                 child: Text(
//                   "Lorem ipsum dolor sit amet consectetur. Id.",
//                   style: GoogleFonts.poppins(
//                     color: const Color.fromRGBO(30, 30, 30, 1),
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               Text(
//                 _formatDuration(_recordDuration),
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               // SizedBox(
//               //   width: Get.width * 0.3,
//               //   height: 50,
//               //   child: Waveform(
//               //     controller: waveformController,
//               //     size: const Size(double.infinity, 50),
//               //     waveStyle: WaveStyle(
//               //       showDurationLabel: false,
//               //       waveColor: AppConstants.purpleColor,
//               //       spacing: 2,
//               //       showBottom: false,
//               //       extendWaveform: true,
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//           const SizedBox(height: 30),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               const Icon(
//                 Icons.headphones_rounded,
//                 size: 40,
//               ),
//               GestureDetector(
//                 onTap: () {
//                   if (_isRecording) {
//                     _stopRecording();
//                   } else {
//                     _startRecording();
//                   }
//                 },
//                 child: CircleAvatar(
//                   radius: 26,
//                   backgroundColor: AppConstants.purpleColor,
//                   child: Center(
//                     child: Icon(
//                       _isRecording ? Icons.stop : FontAwesomeIcons.microphone,
//                       color: Colors.white,
//                       size: 26,
//                     ),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const FaIcon(
//                   FontAwesomeIcons.check,
//                   size: 35,
//                   color: Colors.green,
//                 ),
//                 onPressed: () {
//                   if (_recordFilePath.isNotEmpty) {
//                     Get.back(result: File(_recordFilePath));
//                   }
//                 },
//               ),
//               IconButton(
//                 icon: const FaIcon(
//                   FontAwesomeIcons.xmark,
//                   size: 35,
//                   color: Colors.red,
//                 ),
//                 onPressed: () {
//                   if (_isRecording) {
//                     _stopRecording();
//                   }
//                   Get.back();
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:vedalaya_app/core/themes/app_constants.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class MicrophoneBottomSheet extends StatefulWidget {
//   const MicrophoneBottomSheet({super.key});

//   @override
//   State<MicrophoneBottomSheet> createState() => _MicrophoneBottomSheetState();
// }

// class _MicrophoneBottomSheetState extends State<MicrophoneBottomSheet> {
//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   final FlutterSoundPlayer _player = FlutterSoundPlayer();
//   bool _isRecording = false;
//   bool _isPlaying = false;
//   String _recordFilePath = '';
//   Duration _recordDuration = Duration.zero;
//   Duration _playPosition = Duration.zero;
//   Timer? _timer;
//   Timer? _playTimer;
//   List<double> _waveformData = [];
//   Timer? _waveformTimer;
//   StreamSubscription<RecordingDisposition>? _recorderSubscription;
//   StreamSubscription<PlaybackDisposition>? _playerSubscription;

//   @override
//   void initState() {
//     super.initState();
//     _initRecorder();
//     _initPlayer();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _playTimer?.cancel();
//     _waveformTimer?.cancel();
//     _recorderSubscription?.cancel();
//     _playerSubscription?.cancel();
//     _recorder.closeRecorder();
//     _player.closePlayer();
//     super.dispose();
//   }

//   Future<void> _initRecorder() async {
//     await _recorder.openRecorder();
//   }

//   Future<void> _initPlayer() async {
//     await _player.openPlayer();
//   }

//   Future<void> _startRecording() async {
//     try {
//       if (await Permission.microphone.request().isGranted) {
//         final directory = await getTemporaryDirectory();
//         final filePath = '${directory.path}/recording.aac';

//         await _recorder.startRecorder(
//           toFile: filePath,
//           codec: Codec.aacADTS,
//         );

//         // Listen to recorder disposition for duration updates
//         _recorderSubscription = _recorder.onProgress?.listen((disposition) {
//           setState(() {
//             _recordDuration = disposition.duration;
//           });
//         });

//         // For waveform simulation
//         _waveformTimer =
//             Timer.periodic(const Duration(milliseconds: 200), (timer) {
//           // Simulate waveform data since we can't get actual decibels
//           final randomValue = 0.2 +
//               (0.8 *
//                   (_isRecording
//                       ? (0.5 + 0.5 * DateTime.now().millisecond / 1000)
//                       : 0));
//           setState(() {
//             _waveformData.add(randomValue);
//             if (_waveformData.length > 100) {
//               _waveformData.removeAt(0);
//             }
//           });
//         });

//         setState(() {
//           _isRecording = true;
//           _recordFilePath = filePath;
//           _recordDuration = Duration.zero;
//           _waveformData = [];
//         });

//         _startTimer();
//       }
//     } catch (e) {
//       debugPrint('Error starting recording: $e');
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       await _recorder.stopRecorder();
//       _recorderSubscription?.cancel();
//       _waveformTimer?.cancel();
//       _timer?.cancel();

//       setState(() {
//         _isRecording = false;
//       });

//       debugPrint('Recording saved to: $_recordFilePath');
//     } catch (e) {
//       debugPrint('Error stopping recording: $e');
//     }
//   }

//   Future<void> _playRecording() async {
//     if (_recordFilePath.isEmpty) return;

//     try {
//       await _player.startPlayer(
//         fromURI: _recordFilePath,
//         codec: Codec.aacADTS,
//         whenFinished: () {
//           setState(() {
//             _isPlaying = false;
//             _playPosition = Duration.zero;
//           });
//           _playerSubscription?.cancel();
//         },
//       );

//       // Listen to player disposition for playback position updates
//       _playerSubscription = _player.onProgress?.listen((disposition) {
//         setState(() {
//           _playPosition = disposition.duration;
//         });
//       });

//       setState(() {
//         _isPlaying = true;
//         _playPosition = Duration.zero;
//       });
//     } catch (e) {
//       debugPrint('Error playing recording: $e');
//     }
//   }

//   Future<void> _stopPlaying() async {
//     await _player.stopPlayer();
//     _playerSubscription?.cancel();
//     setState(() {
//       _isPlaying = false;
//       _playPosition = Duration.zero;
//     });
//   }

//   void _startTimer() {
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (!_isRecording) {
//         timer.cancel();
//       }
//     });
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$minutes:$seconds';
//   }

//   Widget _buildWaveform() {
//     if (_waveformData.isEmpty) {
//       return Container(
//         height: 50,
//         width: Get.width * 0.3,
//         color: Colors.grey[300],
//       );
//     }

//     return SizedBox(
//       width: Get.width * 0.3,
//       height: 50,
//       child: CustomPaint(
//         painter: WaveformPainter(_waveformData),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(217, 217, 217, 1),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SizedBox(
//                 height: Get.height * 0.1,
//                 width: Get.width * 0.25,
//                 child: Text(
//                   "Lorem ipsum dolor sit amet consectetur. Id.",
//                   style: GoogleFonts.poppins(
//                     color: const Color.fromRGBO(30, 30, 30, 1),
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               Text(
//                 _isPlaying
//                     ? _formatDuration(_playPosition)
//                     : _formatDuration(_recordDuration),
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               _buildWaveform(),
//             ],
//           ),
//           const SizedBox(height: 30),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   if (_recordFilePath.isEmpty) return;
//                   if (_isPlaying) {
//                     _stopPlaying();
//                   } else {
//                     _playRecording();
//                   }
//                 },
//                 child: Icon(
//                   Icons.headphones_rounded,
//                   size: 40,
//                   color: _recordFilePath.isEmpty
//                       ? Colors.grey
//                       : (_isPlaying ? AppConstants.purpleColor : Colors.black),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   if (_isRecording) {
//                     _stopRecording();
//                   } else {
//                     _startRecording();
//                   }
//                 },
//                 child: CircleAvatar(
//                   radius: 26,
//                   backgroundColor: AppConstants.purpleColor,
//                   child: Center(
//                     child: Icon(
//                       _isRecording ? Icons.stop : FontAwesomeIcons.microphone,
//                       color: Colors.white,
//                       size: 26,
//                     ),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const FaIcon(
//                   FontAwesomeIcons.check,
//                   size: 35,
//                   color: Colors.green,
//                 ),
//                 onPressed: () {
//                   if (_recordFilePath.isNotEmpty) {
//                     Get.back(result: File(_recordFilePath));
//                   }
//                 },
//               ),
//               IconButton(
//                 icon: const FaIcon(
//                   FontAwesomeIcons.xmark,
//                   size: 35,
//                   color: Colors.red,
//                 ),
//                 onPressed: () {
//                   if (_isRecording) {
//                     _stopRecording();
//                   }
//                   if (_isPlaying) {
//                     _stopPlaying();
//                   }
//                   Get.back();
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

// class WaveformPainter extends CustomPainter {
//   final List<double> waveformData;

//   WaveformPainter(this.waveformData);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = AppConstants.purpleColor
//       ..style = PaintingStyle.fill;

//     final centerY = size.height / 2;
//     final barWidth = size.width / waveformData.length;

//     for (var i = 0; i < waveformData.length; i++) {
//       final height = waveformData[i] * size.height * 0.8;
//       final left = i * barWidth;
//       final rect = Rect.fromLTRB(
//         left,
//         centerY - height / 2,
//         left + barWidth - 2, // -2 for spacing between bars
//         centerY + height / 2,
//       );
//       canvas.drawRect(rect, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// import 'dart:io';
// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:vedalaya_app/core/themes/app_constants.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class MicrophoneBottomSheet extends StatefulWidget {
//   const MicrophoneBottomSheet({super.key});

//   @override
//   State<MicrophoneBottomSheet> createState() => _MicrophoneBottomSheetState();
// }

// class _MicrophoneBottomSheetState extends State<MicrophoneBottomSheet> {
//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   final FlutterSoundPlayer _player = FlutterSoundPlayer();
//   bool _isRecording = false;
//   bool _isPlaying = false;
//   String _recordFilePath = '';
//   Duration _recordDuration = Duration.zero;
//   Duration _playPosition = Duration.zero;
//   Timer? _timer;
//   StreamSubscription<RecordingDisposition>? _recorderSubscription;
//   StreamSubscription<PlaybackDisposition>? _playerSubscription;
//   List<double> _waveformData = List.filled(50, 0.1); // Initialize with small values
//   int _waveformIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _initRecorder();
//     _initPlayer();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _recorderSubscription?.cancel();
//     _playerSubscription?.cancel();
//     _recorder.closeRecorder();
//     _player.closePlayer();
//     super.dispose();
//   }

//   Future<void> _initRecorder() async {
//     await _recorder.openRecorder();
//   }

//   Future<void> _initPlayer() async {
//     await _player.openPlayer();
//   }

//   Future<void> _startRecording() async {
//     try {
//       if (await Permission.microphone.request().isGranted) {
//         final directory = await getTemporaryDirectory();
//         final filePath = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

//         await _recorder.startRecorder(
//           toFile: filePath,
//           codec: Codec.aacADTS,
//         );

//         // Reset timer and waveform
//         setState(() {
//           _isRecording = true;
//           _recordFilePath = filePath;
//           _recordDuration = Duration.zero;
//           _waveformData = List.filled(50, 0.1);
//           _waveformIndex = 0;
//         });

//         // Start timer
//         _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//           setState(() {
//             _recordDuration += const Duration(milliseconds: 100);
//           });
//         });

//         // Listen to recorder for waveform simulation
//         _recorderSubscription = _recorder.onProgress?.listen((disposition) {
//           // Simulate waveform based on recording activity
//           final randomFactor = Random().nextDouble() * 0.3;
//           final baseLevel = 0.3 + (disposition.decibels != null
//               ? (disposition.decibels! + 80) / 160
//               : randomFactor);

//           setState(() {
//             _waveformData[_waveformIndex] = baseLevel.clamp(0.1, 1.0);
//             _waveformIndex = (_waveformIndex + 1) % _waveformData.length;
//           });
//         });
//       }
//     } catch (e) {
//       debugPrint('Error starting recording: $e');
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       await _recorder.stopRecorder();
//       _timer?.cancel();
//       _recorderSubscription?.cancel();

//       setState(() {
//         _isRecording = false;
//       });
//     } catch (e) {
//       debugPrint('Error stopping recording: $e');
//     }
//   }

//   Future<void> _playRecording() async {
//     if (_recordFilePath.isEmpty) return;

//     try {
//       await _player.startPlayer(
//         fromURI: _recordFilePath,
//         codec: Codec.aacADTS,
//         whenFinished: () {
//           setState(() {
//             _isPlaying = false;
//             _playPosition = Duration.zero;
//           });
//           _playerSubscription?.cancel();
//         },
//       );

//       _playerSubscription = _player.onProgress?.listen((disposition) {
//         setState(() {
//           _playPosition = disposition.duration;
//         });
//       });

//       setState(() {
//         _isPlaying = true;
//       });
//     } catch (e) {
//       debugPrint('Error playing recording: $e');
//     }
//   }

//   Future<void> _stopPlaying() async {
//     await _player.stopPlayer();
//     _playerSubscription?.cancel();
//     setState(() {
//       _isPlaying = false;
//       _playPosition = Duration.zero;
//     });
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     final centiseconds = twoDigits((duration.inMilliseconds % 1000) ~/ 10);
//     return '$minutes:$seconds.$centiseconds';
//   }

//   Widget _buildWaveform() {
//     return SizedBox(
//       width: Get.width * 0.3,
//       height: 50,
//       child: CustomPaint(
//         painter: _WaveformPainter(_waveformData, _waveformIndex),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(217, 217, 217, 1),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SizedBox(
//                 height: Get.height * 0.1,
//                 width: Get.width * 0.25,
//                 child: Text(
//                   "Record your message",
//                   style: GoogleFonts.poppins(
//                     color: const Color.fromRGBO(30, 30, 30, 1),
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               Text(
//                 _isPlaying
//                     ? _formatDuration(_playPosition)
//                     : _formatDuration(_recordDuration),
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               _buildWaveform(),
//             ],
//           ),
//           const SizedBox(height: 30),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   if (_recordFilePath.isEmpty) return;
//                   if (_isPlaying) {
//                     _stopPlaying();
//                   } else {
//                     _playRecording();
//                   }
//                 },
//                 child: Icon(
//                   Icons.headphones_rounded,
//                   size: 40,
//                   color: _recordFilePath.isEmpty
//                       ? Colors.grey
//                       : (_isPlaying ? AppConstants.purpleColor : Colors.black),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   if (_isRecording) {
//                     _stopRecording();
//                   } else {
//                     _startRecording();
//                   }
//                 },
//                 child: CircleAvatar(
//                   radius: 26,
//                   backgroundColor: AppConstants.purpleColor,
//                   child: Center(
//                     child: Icon(
//                       _isRecording ? Icons.stop : FontAwesomeIcons.microphone,
//                       color: Colors.white,
//                       size: 26,
//                     ),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const FaIcon(
//                   FontAwesomeIcons.check,
//                   size: 35,
//                   color: Colors.green,
//                 ),
//                 onPressed: () {
//                   if (_recordFilePath.isNotEmpty) {
//                     Get.back(result: File(_recordFilePath));
//                   }
//                 },
//               ),
//               IconButton(
//                 icon: const FaIcon(
//                   FontAwesomeIcons.xmark,
//                   size: 35,
//                   color: Colors.red,
//                 ),
//                 onPressed: () {
//                   if (_isRecording) _stopRecording();
//                   if (_isPlaying) _stopPlaying();
//                   Get.back();
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

// class _WaveformPainter extends CustomPainter {
//   final List<double> waveformData;
//   final int currentIndex;

//   _WaveformPainter(this.waveformData, this.currentIndex);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = AppConstants.purpleColor
//       ..style = PaintingStyle.fill;

//     final centerY = size.height / 2;
//     final barWidth = size.width / waveformData.length;

//     for (var i = 0; i < waveformData.length; i++) {
//       // Create a circular buffer effect
//       final dataIndex = (currentIndex + i) % waveformData.length;
//       final height = waveformData[dataIndex] * size.height * 0.8;

//       // Make the bars smoother with rounded tops
//       final left = i * barWidth;
//       final rect = Rect.fromLTRB(
//         left,
//         centerY - height / 2,
//         left + barWidth - 1, // -1 for spacing
//         centerY + height / 2,
//       );

//       final radius = Radius.circular(barWidth / 2);
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(rect, radius),
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// import 'dart:async';
// import 'dart:io';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:vedalaya_app/core/themes/app_constants.dart';

// class MicrophoneBottomSheet extends StatefulWidget {
//   const MicrophoneBottomSheet({super.key});

//   @override
//   State<MicrophoneBottomSheet> createState() => _MicrophoneBottomSheetState();
// }

// class _MicrophoneBottomSheetState extends State<MicrophoneBottomSheet> {
//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   final FlutterSoundPlayer _player = FlutterSoundPlayer();
//   bool _isRecording = false;
//   bool _isPlaying = false;
//   String _recordFilePath = '';
//   Duration _recordDuration = Duration.zero;
//   Duration _playPosition = Duration.zero;
//   Timer? _timer;
//   StreamSubscription<RecordingDisposition>? _recorderSubscription;
//   StreamSubscription<PlaybackDisposition>? _playerSubscription;
//   List<double> _waveformData = List.filled(50, 0.1);
//   int _waveformIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _initRecorder();
//     _initPlayer();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _recorderSubscription?.cancel();
//     _playerSubscription?.cancel();
//     _recorder.closeRecorder();
//     _player.closePlayer();
//     super.dispose();
//   }

//   Future<void> _initRecorder() async {
//     await _recorder.openRecorder();
//   }

//   Future<void> _initPlayer() async {
//     await _player.openPlayer();
//   }

//   Future<void> _startRecording() async {
//     try {
//       if (await Permission.microphone.request().isGranted) {
//         final directory = await getTemporaryDirectory();
//         final filePath =
//             '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

//         await _recorder.startRecorder(
//           toFile: filePath,
//           codec: Codec.aacADTS,
//         );

//         _recorderSubscription?.cancel();
//         _recorderSubscription = _recorder.onProgress?.listen((disposition) {
//           final randomFactor = Random().nextDouble() * 0.3;
//           final baseLevel = 0.3 +
//               (disposition.decibels != null
//                   ? (disposition.decibels! + 80) / 160
//                   : randomFactor);

//           setState(() {
//             _waveformData[_waveformIndex] = baseLevel.clamp(0.1, 1.0);
//             _waveformIndex = (_waveformIndex + 1) % _waveformData.length;
//           });
//         });

//         setState(() {
//           _isRecording = true;
//           _recordFilePath = filePath;
//           _recordDuration = Duration.zero;
//           _waveformData = List.filled(50, 0.1);
//           _waveformIndex = 0;
//         });

//         _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//           setState(() {
//             _recordDuration += const Duration(milliseconds: 100);
//           });
//         });
//       }
//     } catch (e) {
//       debugPrint('Error starting recording: $e');
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       await _recorder.stopRecorder();
//       _timer?.cancel();
//       _recorderSubscription?.cancel();
//       _recorderSubscription = null;
//       setState(() {
//         _isRecording = false;
//       });
//     } catch (e) {
//       debugPrint('Error stopping recording: $e');
//     }
//   }

//   Future<void> _playRecording() async {
//     if (_recordFilePath.isEmpty) return;

//     try {
//       await _player.startPlayer(
//         fromURI: _recordFilePath,
//         codec: Codec.aacADTS,
//         whenFinished: () {
//           setState(() {
//             _isPlaying = false;
//             _playPosition = Duration.zero;
//           });
//           _playerSubscription?.cancel();
//           _playerSubscription = null;
//         },
//       );

//       _playerSubscription?.cancel();
//       _playerSubscription = _player.onProgress?.listen((disposition) {
//         setState(() {
//           _playPosition = disposition.position;
//         });
//       });

//       setState(() {
//         _isPlaying = true;
//       });
//     } catch (e) {
//       debugPrint('Error playing recording: $e');
//     }
//   }

//   Future<void> _stopPlaying() async {
//     await _player.stopPlayer();
//     _playerSubscription?.cancel();
//     _playerSubscription = null;
//     setState(() {
//       _isPlaying = false;
//       _playPosition = Duration.zero;
//     });
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     final centiseconds = twoDigits((duration.inMilliseconds % 1000) ~/ 10);
//     return '$minutes:$seconds.$centiseconds';
//   }

//   Widget _buildWaveform() {
//     return SizedBox(
//       width: Get.width * 0.3,
//       height: 50,
//       child: CustomPaint(
//         painter: _WaveformPainter(_waveformData, _waveformIndex),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(217, 217, 217, 1),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SizedBox(
//                 height: Get.height * 0.1,
//                 width: Get.width * 0.25,
//                 child: Text(
//                   "Record your message",
//                   style: GoogleFonts.poppins(
//                     color: const Color.fromRGBO(30, 30, 30, 1),
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               Text(
//                 _isPlaying
//                     ? _formatDuration(_playPosition)
//                     : _formatDuration(_recordDuration),
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               _buildWaveform(),
//             ],
//           ),
//           const SizedBox(height: 30),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   if (_recordFilePath.isEmpty) return;
//                   if (_isPlaying) {
//                     _stopPlaying();
//                   } else {
//                     _playRecording();
//                   }
//                 },
//                 child: Icon(
//                   Icons.headphones_rounded,
//                   size: 40,
//                   color: _recordFilePath.isEmpty
//                       ? Colors.grey
//                       : (_isPlaying ? AppConstants.purpleColor : Colors.black),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   if (_isRecording) {
//                     _stopRecording();
//                   } else {
//                     _startRecording();
//                   }
//                 },
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeInOut,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: _isRecording
//                         ? [
//                             BoxShadow(
//                               color: AppConstants.purpleColor.withOpacity(0.5),
//                               // blurRadius: 20,
//                               spreadRadius: 8,
//                             ),
//                             BoxShadow(
//                               color: AppConstants.purpleColor.withOpacity(0.2),
//                               // blurRadius: 40,
//                               spreadRadius: 16,
//                             ),
//                           ]
//                         : [],
//                   ),
//                   child: CircleAvatar(
//                     radius: 26,
//                     backgroundColor: AppConstants.purpleColor,
//                     child: Center(
//                       child: Icon(
//                         _isRecording ? Icons.stop : FontAwesomeIcons.microphone,
//                         color: Colors.white,
//                         size: 26,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const FaIcon(
//                   FontAwesomeIcons.check,
//                   size: 35,
//                   color: Colors.green,
//                 ),
//                 onPressed: () {
//                   if (_recordFilePath.isNotEmpty) {
//                     Get.back(result: File(_recordFilePath));
//                   }
//                 },
//               ),
//               IconButton(
//                 icon: const FaIcon(
//                   FontAwesomeIcons.xmark,
//                   size: 35,
//                   color: Colors.red,
//                 ),
//                 onPressed: () {
//                   if (_isRecording) _stopRecording();
//                   if (_isPlaying) _stopPlaying();
//                   Get.back();
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

// class _WaveformPainter extends CustomPainter {
//   final List<double> waveformData;
//   final int currentIndex;

//   _WaveformPainter(this.waveformData, this.currentIndex);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = AppConstants.purpleColor
//       ..style = PaintingStyle.fill;

//     final centerY = size.height / 2;
//     final barWidth = size.width / waveformData.length;

//     for (var i = 0; i < waveformData.length; i++) {
//       final dataIndex = (currentIndex + i) % waveformData.length;
//       final height = waveformData[dataIndex] * size.height * 0.8;
//       final left = i * barWidth;
//       final rect = Rect.fromLTRB(
//         left,
//         centerY - height / 2,
//         left + barWidth - 1,
//         centerY + height / 2,
//       );
//       final radius = Radius.circular(barWidth / 2);
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(rect, radius),
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// import 'dart:async';
// import 'dart:io';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:vedalaya_app/core/themes/app_constants.dart';

// class MicrophoneBottomSheet extends StatefulWidget {
//   const MicrophoneBottomSheet({super.key});

//   @override
//   State<MicrophoneBottomSheet> createState() => _MicrophoneBottomSheetState();
// }

// class _MicrophoneBottomSheetState extends State<MicrophoneBottomSheet> {
//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   final FlutterSoundPlayer _player = FlutterSoundPlayer();
//   bool _isRecording = false;
//   bool _isPlaying = false;
//   String _recordFilePath = '';
//   Duration _recordDuration = Duration.zero;
//   Duration _playPosition = Duration.zero;
//   Timer? _timer;
//   StreamSubscription<RecordingDisposition>? _recorderSubscription;
//   StreamSubscription<PlaybackDisposition>? _playerSubscription;
//   final List<double> _waveformData = List.filled(50, 0.1);
//   int _waveformIndex = 0;
//   Timer? _waveTimer;

//   @override
//   void initState() {
//     super.initState();
//     _initRecorder();
//     _initPlayer();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _waveTimer?.cancel();
//     _recorderSubscription?.cancel();
//     _playerSubscription?.cancel();
//     _recorder.closeRecorder();
//     _player.closePlayer();
//     super.dispose();
//   }

//   Future<void> _initRecorder() async {
//     await _recorder.openRecorder();
//   }

//   Future<void> _initPlayer() async {
//     await _player.openPlayer();
//   }

//   Future<void> _startRecording() async {
//     try {
//       if (await Permission.microphone.request().isGranted) {
//         final directory = await getTemporaryDirectory();
//         final filePath =
//             '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

//         await _recorder.startRecorder(
//           toFile: filePath,
//           codec: Codec.aacADTS,
//         );

//         // Start waveform animation
//         _waveTimer?.cancel();
//         _waveTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//           setState(() {
//             final randomValue = 0.2 + Random().nextDouble() * 0.8;
//             _waveformData[_waveformIndex] = randomValue;
//             _waveformIndex = (_waveformIndex + 1) % _waveformData.length;
//           });
//         });

//         setState(() {
//           _isRecording = true;
//           _recordFilePath = filePath;
//           _recordDuration = Duration.zero;
//         });

//         _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//           setState(() {
//             _recordDuration += const Duration(milliseconds: 100);
//           });
//         });
//       }
//     } catch (e) {
//       debugPrint('Error starting recording: $e');
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       await _recorder.stopRecorder();
//       _timer?.cancel();
//       _waveTimer?.cancel();
//       setState(() {
//         _isRecording = false;
//       });
//     } catch (e) {
//       debugPrint('Error stopping recording: $e');
//     }
//   }

//   Future<void> _playRecording() async {
//     if (_recordFilePath.isEmpty) return;

//     try {
//       await _player.startPlayer(
//         fromURI: _recordFilePath,
//         codec: Codec.aacADTS,
//         whenFinished: () {
//           setState(() {
//             _isPlaying = false;
//             _playPosition = Duration.zero;
//           });
//         },
//       );

//       setState(() {
//         _isPlaying = true;
//       });
//     } catch (e) {
//       debugPrint('Error playing recording: $e');
//     }
//   }

//   Future<void> _stopPlaying() async {
//     await _player.stopPlayer();
//     setState(() {
//       _isPlaying = false;
//       _playPosition = Duration.zero;
//     });
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     final centiseconds = twoDigits((duration.inMilliseconds % 1000) ~/ 10);
//     return '$minutes:$seconds.$centiseconds';
//   }

//   Widget _buildWaveform() {
//     return SizedBox(
//       width: Get.width * 0.3,
//       height: 50,
//       child: CustomPaint(
//         painter: _WaveformPainter(_waveformData),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(217, 217, 217, 1),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SizedBox(
//                 height: Get.height * 0.1,
//                 width: Get.width * 0.25,
//                 child: Text(
//                   "Record your message",
//                   style: GoogleFonts.poppins(
//                     color: const Color.fromRGBO(30, 30, 30, 1),
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               Text(
//                 _isPlaying
//                     ? _formatDuration(_playPosition)
//                     : _formatDuration(_recordDuration),
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               _buildWaveform(),
//             ],
//           ),
//           const SizedBox(height: 30),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   if (_recordFilePath.isEmpty) return;
//                   if (_isPlaying) {
//                     _stopPlaying();
//                   } else {
//                     _playRecording();
//                   }
//                 },
//                 child: Icon(
//                   Icons.headphones_rounded,
//                   size: 40,
//                   color: _recordFilePath.isEmpty
//                       ? Colors.grey
//                       : (_isPlaying ? AppConstants.purpleColor : Colors.black),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   if (_isRecording) {
//                     _stopRecording();
//                   } else {
//                     _startRecording();
//                   }
//                 },
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeInOut,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: _isRecording
//                         ? [
//                             BoxShadow(
//                               color: AppConstants.purpleColor.withOpacity(0.5),
//                               // blurRadius: 20,
//                               spreadRadius: 8,
//                             ),
//                             BoxShadow(
//                               color: AppConstants.purpleColor.withOpacity(0.2),
//                               // blurRadius: 40,
//                               spreadRadius: 16,
//                             ),
//                           ]
//                         : [],
//                   ),
//                   child: CircleAvatar(
//                     radius: 26,
//                     backgroundColor: AppConstants.purpleColor,
//                     child: Center(
//                       child: Icon(
//                         _isRecording ? Icons.stop : FontAwesomeIcons.microphone,
//                         color: Colors.white,
//                         size: 26,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const FaIcon(
//                   FontAwesomeIcons.check,
//                   size: 35,
//                   color: Colors.green,
//                 ),
//                 onPressed: () {
//                   if (_recordFilePath.isNotEmpty) {
//                     Get.back(result: File(_recordFilePath));
//                   }
//                 },
//               ),
//               IconButton(
//                 icon: const FaIcon(
//                   FontAwesomeIcons.xmark,
//                   size: 35,
//                   color: Colors.red,
//                 ),
//                 onPressed: () {
//                   if (_isRecording) _stopRecording();
//                   if (_isPlaying) _stopPlaying();
//                   Get.back();
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

// class _WaveformPainter extends CustomPainter {
//   final List<double> waveformData;

//   _WaveformPainter(this.waveformData);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = AppConstants.purpleColor
//       ..style = PaintingStyle.fill;

//     final centerY = size.height / 2;
//     final barWidth = size.width / waveformData.length * 1.5; // Wider bars

//     for (var i = 0; i < 35; i++) {
//       final height = waveformData[i] * size.height * 0.8;
//       final left = i * barWidth;
//       final rect = Rect.fromLTRB(
//         left,
//         centerY - height / 2,
//         left + barWidth - 2, // Slightly less spacing
//         centerY + height / 2,
//       );
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(rect, Radius.circular(barWidth / 4)),
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:vedalaya_app/core/themes/app_constants.dart';
// import 'package:video_player/video_player.dart';

// class MicrophoneBottomSheet extends StatefulWidget {
//   final VideoPlayerController videoController;

//   const MicrophoneBottomSheet({
//     super.key,
//     required this.videoController,
//   });

//   @override
//   State<MicrophoneBottomSheet> createState() => _MicrophoneBottomSheetState();
// }

// class _MicrophoneBottomSheetState extends State<MicrophoneBottomSheet> {
//   final FlutterSoundRecorder _micRecorder = FlutterSoundRecorder();
//   bool _isRecording = false;
//   bool _isPlaying = false;
//   String _recordFilePath = '';
//   Duration _recordDuration = Duration.zero;
//   Duration _playPosition = Duration.zero;
//   Timer? _timer;
//   Timer? _waveTimer;
//   final List<double> _waveformData = List.filled(50, 0.1);
//   int _waveformIndex = 0;
//   double _videoAudioLevel = 0.0;
//   final double _micAudioLevel = 0.0;
//   bool _isVoiceDetected = false;
//   final double _voiceThreshold = 0.02;

//   @override
//   void initState() {
//     super.initState();
//     _initRecorder();
//     _startAudioMonitoring();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _waveTimer?.cancel();
//     _micRecorder.closeRecorder();
//     super.dispose();
//   }

//   Future<void> _initRecorder() async {
//     await _micRecorder.openRecorder();
//     _micRecorder.setSubscriptionDuration(const Duration(milliseconds: 50));
//   }

//   void _startAudioMonitoring() {
//     _waveTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (_isRecording) {
//         setState(() {
//           // Simulate waveform updates
//           _waveformData[_waveformIndex] = 0.2 + Random().nextDouble() * 0.8;
//           _waveformIndex = (_waveformIndex + 1) % _waveformData.length;

//           // Detect voice
//           _isVoiceDetected = _micAudioLevel > _voiceThreshold;
//         });
//       }
//     });
//   }

//   Future<void> _startRecording() async {
//     try {
//       if (await Permission.microphone.request().isGranted) {
//         final directory = await getTemporaryDirectory();
//         _recordFilePath =
//             '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

//         // Start microphone recording
//         await _micRecorder.startRecorder(
//           toFile: _recordFilePath,
//           codec: Codec.aacADTS,
//         );

//         // Start monitoring video audio level
//         widget.videoController.addListener(_updateVideoAudioLevel);

//         setState(() {
//           _isRecording = true;
//           _recordDuration = Duration.zero;
//         });

//         _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//           setState(() {
//             _recordDuration += const Duration(milliseconds: 100);
//           });
//         });
//       }
//     } catch (e) {
//       debugPrint('Error starting recording: $e');
//     }
//   }

//   void _updateVideoAudioLevel() {
//     // This is a simplified version - in a real app you'd analyze the audio frames
//     setState(() {
//       _videoAudioLevel = 0.3 + Random().nextDouble() * 0.5;
//     });
//   }

//   Future<void> _stopRecording() async {
//     try {
//       await _micRecorder.stopRecorder();
//       widget.videoController.removeListener(_updateVideoAudioLevel);

//       _timer?.cancel();
//       setState(() {
//         _isRecording = false;
//       });

//       // Here you would mix the video audio with microphone audio
//       // This requires FFmpeg or similar audio processing
//       await _mixAudioTracks();
//     } catch (e) {
//       debugPrint('Error stopping recording: $e');
//     }
//   }

//   Future<void> _mixAudioTracks() async {
//     // This is where you would mix the video audio (from widget.videoController)
//     // with the microphone recording (_recordFilePath)
//     // Implementation depends on your audio processing library
//     debugPrint('Audio mixing would happen here');
//   }

//   // Future<void> _playRecording() async {
//   //   if (_recordFilePath.isEmpty) return;

//   //   try {
//   //     // In a real app, you'd play the mixed audio file
//   //     setState(() {
//   //       _isPlaying = true;
//   //     });
//   //   } catch (e) {
//   //     debugPrint('Error playing recording: $e');
//   //   }
//   // }

//   // Future<void> _stopPlaying() async {
//   //   setState(() {
//   //     _isPlaying = false;
//   //     _playPosition = Duration.zero;
//   //   });
//   // }

//   Future<void> _playRecording() async {
//     if (_recordFilePath.isEmpty) return;

//     try {
//       // Pause the background video first
//       final wasVideoPlaying = widget.videoController.value.isPlaying;
//       if (wasVideoPlaying) {
//         await widget.videoController.pause();
//       }

//       setState(() {
//         _isPlaying = true;
//       });

//       // In a real app, you'd play the mixed audio file here
//       // When playback completes:
//       Future.delayed(const Duration(seconds: 3), () {
//         // Simulate playback
//         if (mounted) {
//           setState(() => _isPlaying = false);
//           // Resume video if it was playing
//           if (wasVideoPlaying) {
//             widget.videoController.play();
//           }
//         }
//       });
//     } catch (e) {
//       debugPrint('Error playing recording: $e');
//       // Ensure video resumes even if error occurs
//       if (widget.videoController.value.isPlaying) {
//         widget.videoController.play();
//       }
//     }
//   }

//   Future<void> _stopPlaying() async {
//     setState(() {
//       _isPlaying = false;
//       _playPosition = Duration.zero;
//     });
//     // Resume video playback if needed
//     if (!widget.videoController.value.isPlaying) {
//       widget.videoController.play();
//     }
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     final centiseconds = twoDigits((duration.inMilliseconds % 1000) ~/ 10);
//     return '$minutes:$seconds.$centiseconds';
//   }

//   Widget _buildWaveform() {
//     return SizedBox(
//       width: Get.width * 0.3,
//       height: 50,
//       child: CustomPaint(
//         painter: _WaveformPainter(_waveformData),
//       ),
//     );
//   }

//   Widget _buildAudioLevelIndicator() {
//     return Row(
//       children: [
//         _buildLevelBar(_videoAudioLevel, Colors.blue),
//         const SizedBox(width: 8),
//         _buildLevelBar(_micAudioLevel, Colors.green),
//       ],
//     );
//   }

//   Widget _buildLevelBar(double level, Color color) {
//     return Container(
//       width: 4,
//       height: 20 * level,
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(217, 217, 217, 1),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SizedBox(
//                 height: Get.height * 0.1,
//                 width: Get.width * 0.25,
//                 child: Text(
//                   "Record your practice",
//                   style: GoogleFonts.poppins(
//                     color: const Color.fromRGBO(30, 30, 30, 1),
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               Text(
//                 _isPlaying
//                     ? _formatDuration(_playPosition)
//                     : _formatDuration(_recordDuration),
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               _buildWaveform(),
//             ],
//           ),
//           const SizedBox(height: 10),
//           _buildAudioLevelIndicator(),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               GestureDetector(
//                 onTap: () async {
//                   if (_recordFilePath.isEmpty) return;
//                   if (_isPlaying) {
//                     await _stopPlaying();
//                   } else {
//                     await _playRecording();
//                   }
//                 },
//                 child: Icon(
//                   Icons.headphones_rounded,
//                   size: 40,
//                   color: _recordFilePath.isEmpty
//                       ? Colors.grey
//                       : (_isPlaying ? AppConstants.purpleColor : Colors.black),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   if (_isRecording) {
//                     _stopRecording();
//                   } else {
//                     _startRecording();
//                   }
//                 },
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeInOut,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: _isRecording
//                         ? [
//                             BoxShadow(
//                               color: AppConstants.purpleColor.withOpacity(0.5),
//                               spreadRadius: 8,
//                             ),
//                             BoxShadow(
//                               color: AppConstants.purpleColor.withOpacity(0.2),
//                               spreadRadius: 16,
//                             ),
//                           ]
//                         : [],
//                   ),
//                   child: CircleAvatar(
//                     radius: 26,
//                     backgroundColor: AppConstants.purpleColor,
//                     child: Center(
//                       child: Icon(
//                         _isRecording ? Icons.stop : FontAwesomeIcons.microphone,
//                         color: Colors.white,
//                         size: 26,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const FaIcon(
//                   FontAwesomeIcons.check,
//                   size: 35,
//                   color: Colors.green,
//                 ),
//                 onPressed: () {
//                   if (_recordFilePath.isNotEmpty) {
//                     Get.back(result: File(_recordFilePath));
//                   }
//                 },
//               ),
//               IconButton(
//                 icon: const FaIcon(
//                   FontAwesomeIcons.xmark,
//                   size: 35,
//                   color: Colors.red,
//                 ),
//                 onPressed: () {
//                   if (_isRecording) _stopRecording();
//                   if (_isPlaying) _stopPlaying();
//                   Get.back();
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Text(
//             _isVoiceDetected ? "Voice detected - Recording" : "Listening...",
//             style: GoogleFonts.poppins(
//               fontSize: 14,
//               color: _isVoiceDetected ? Colors.green : Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _WaveformPainter extends CustomPainter {
//   final List<double> waveformData;

//   _WaveformPainter(this.waveformData);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = AppConstants.purpleColor
//       ..style = PaintingStyle.fill;

//     final centerY = size.height / 2;
//     final barWidth = size.width / waveformData.length * 1.5;

//     for (var i = 0; i < 35; i++) {
//       final height = waveformData[i] * size.height * 0.8;
//       final left = i * barWidth;
//       final rect = Rect.fromLTRB(
//         left,
//         centerY - height / 2,
//         left + barWidth - 2,
//         centerY + height / 2,
//       );
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(rect, Radius.circular(barWidth / 4)),
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:vedalaya_app/core/themes/app_constants.dart';
// import 'package:video_player/video_player.dart';

// class MicrophoneBottomSheet extends StatefulWidget {
//   final VideoPlayerController videoController;

//   const MicrophoneBottomSheet({
//     super.key,
//     required this.videoController,
//   });

//   @override
//   State<MicrophoneBottomSheet> createState() => _MicrophoneBottomSheetState();
// }

// class _MicrophoneBottomSheetState extends State<MicrophoneBottomSheet> {
//   final FlutterSoundRecorder _micRecorder = FlutterSoundRecorder();
//   bool _isRecording = false;
//   bool _isPlaying = false;
//   String _recordFilePath = '';
//   Duration _recordDuration = Duration.zero;
//   Duration _playPosition = Duration.zero;
//   Timer? _timer;
//   Timer? _waveTimer;
//   final List<double> _waveformData = List.filled(50, 0.1);
//   int _waveformIndex = 0;
//   double _videoAudioLevel = 0.0;
//   final double _micAudioLevel = 0.0;
//   bool _isVoiceDetected = false;
//   final double _voiceThreshold = 0.02;
//   bool _wasVideoPlaying = false;
//   bool _showPlaySongMessage = false;

//   @override
//   void initState() {
//     super.initState();
//     _initRecorder();
//     _startAudioMonitoring();

//     // Check if video is playing when bottom sheet opens
//     _wasVideoPlaying = widget.videoController.value.isPlaying;
//     if (!_wasVideoPlaying) {
//       setState(() {
//         _showPlaySongMessage = true;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _waveTimer?.cancel();
//     _micRecorder.closeRecorder();
//     super.dispose();
//   }

//   Future<void> _initRecorder() async {
//     await _micRecorder.openRecorder();
//     _micRecorder.setSubscriptionDuration(const Duration(milliseconds: 50));
//   }

//   void _startAudioMonitoring() {
//     _waveTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (_isRecording) {
//         setState(() {
//           // Simulate waveform updates
//           _waveformData[_waveformIndex] = 0.2 + Random().nextDouble() * 0.8;
//           _waveformIndex = (_waveformIndex + 1) % _waveformData.length;

//           // Detect voice
//           _isVoiceDetected = _micAudioLevel > _voiceThreshold;
//         });
//       }
//     });
//   }

//   Future<void> _startRecording() async {
//     // Check if video is playing
//     if (!widget.videoController.value.isPlaying) {
//       setState(() {
//         _showPlaySongMessage = true;
//       });
//       return;
//     }

//     try {
//       if (await Permission.microphone.request().isGranted) {
//         final directory = await getTemporaryDirectory();
//         _recordFilePath =
//             '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

//         // Start microphone recording
//         await _micRecorder.startRecorder(
//           toFile: _recordFilePath,
//           codec: Codec.aacADTS,
//         );

//         setState(() {
//           _isRecording = true;
//           _recordDuration = Duration.zero;
//           _showPlaySongMessage = false;
//         });

//         _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//           setState(() {
//             _recordDuration += const Duration(milliseconds: 100);
//           });
//         });
//       }
//     } catch (e) {
//       debugPrint('Error starting recording: $e');
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       await _micRecorder.stopRecorder();

//       _timer?.cancel();
//       setState(() {
//         _isRecording = false;
//       });

//       // Here you would mix the video audio with microphone audio
//       // For demo purposes, we'll just use the microphone recording
//     } catch (e) {
//       debugPrint('Error stopping recording: $e');
//     }
//   }

//   Future<void> _playRecording() async {
//     if (_recordFilePath.isEmpty) return;

//     try {
//       // Pause the background video first
//       _wasVideoPlaying = widget.videoController.value.isPlaying;
//       if (_wasVideoPlaying) {
//         await widget.videoController.pause();
//       }

//       setState(() {
//         _isPlaying = true;
//       });

//       // Simulate playback duration matching the recording length
//       final playbackDuration = _recordDuration;
//       final startTime = DateTime.now();

//       _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//         final elapsed = DateTime.now().difference(startTime);
//         setState(() {
//           _playPosition = elapsed;
//         });

//         if (elapsed >= playbackDuration) {
//           timer.cancel();
//           if (mounted) {
//             setState(() {
//               _isPlaying = false;
//               _playPosition = Duration.zero;
//             });
//             // Resume video if it was playing
//             if (_wasVideoPlaying) {
//               widget.videoController.play();
//             }
//           }
//         }
//       });
//     } catch (e) {
//       debugPrint('Error playing recording: $e');
//       // Ensure video resumes even if error occurs
//       if (_wasVideoPlaying && !widget.videoController.value.isPlaying) {
//         widget.videoController.play();
//       }
//     }
//   }

//   Future<void> _stopPlaying() async {
//     _timer?.cancel();
//     setState(() {
//       _isPlaying = false;
//       _playPosition = Duration.zero;
//     });
//     // Resume video playback if needed
//     if (_wasVideoPlaying && !widget.videoController.value.isPlaying) {
//       widget.videoController.play();
//     }
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$minutes:$seconds';
//   }

//   Widget _buildWaveform() {
//     return SizedBox(
//       width: Get.width * 0.3,
//       height: 50,
//       child: CustomPaint(
//         painter: _WaveformPainter(_waveformData),
//       ),
//     );
//   }

//   Widget _buildAudioLevelIndicator() {
//     return Row(
//       children: [
//         _buildLevelBar(_videoAudioLevel, Colors.blue),
//         const SizedBox(width: 8),
//         _buildLevelBar(_micAudioLevel, Colors.green),
//       ],
//     );
//   }

//   Widget _buildLevelBar(double level, Color color) {
//     return Container(
//       width: 4,
//       height: 20 * level,
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(217, 217, 217, 1),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SizedBox(
//                 height: Get.height * 0.1,
//                 width: Get.width * 0.25,
//                 child: Text(
//                   "Record your practice",
//                   style: GoogleFonts.poppins(
//                     color: const Color.fromRGBO(30, 30, 30, 1),
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               Text(
//                 _isPlaying
//                     ? _formatDuration(_playPosition)
//                     : _formatDuration(_recordDuration),
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               _buildWaveform(),
//             ],
//           ),
//           const SizedBox(height: 10),
//           _buildAudioLevelIndicator(),
//           if (_showPlaySongMessage)
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               child: Text(
//                 "Please play the song first to start recording",
//                 style: GoogleFonts.poppins(
//                   color: Colors.red,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               GestureDetector(
//                 onTap: () async {
//                   if (_recordFilePath.isEmpty) return;
//                   if (_isPlaying) {
//                     await _stopPlaying();
//                   } else {
//                     await _playRecording();
//                   }
//                 },
//                 child: Icon(
//                   Icons.headphones_rounded,
//                   size: 40,
//                   color: _recordFilePath.isEmpty
//                       ? Colors.grey
//                       : (_isPlaying ? AppConstants.purpleColor : Colors.black),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   if (_isRecording) {
//                     _stopRecording();
//                   } else {
//                     _startRecording();
//                   }
//                 },
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeInOut,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     boxShadow: _isRecording
//                         ? [
//                             BoxShadow(
//                               color: AppConstants.purpleColor.withOpacity(0.5),
//                               spreadRadius: 8,
//                             ),
//                             BoxShadow(
//                               color: AppConstants.purpleColor.withOpacity(0.2),
//                               spreadRadius: 16,
//                             ),
//                           ]
//                         : [],
//                   ),
//                   child: CircleAvatar(
//                     radius: 26,
//                     backgroundColor: AppConstants.purpleColor,
//                     child: Center(
//                       child: Icon(
//                         _isRecording ? Icons.stop : FontAwesomeIcons.microphone,
//                         color: Colors.white,
//                         size: 26,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const FaIcon(
//                   FontAwesomeIcons.check,
//                   size: 35,
//                   color: Colors.green,
//                 ),
//                 onPressed: () {
//                   if (_recordFilePath.isNotEmpty) {
//                     Get.back(result: File(_recordFilePath));
//                   }
//                 },
//               ),
//               IconButton(
//                 icon: const FaIcon(
//                   FontAwesomeIcons.xmark,
//                   size: 35,
//                   color: Colors.red,
//                 ),
//                 onPressed: () {
//                   if (_isRecording) _stopRecording();
//                   if (_isPlaying) _stopPlaying();
//                   // Resume video if it was playing
//                   if (_wasVideoPlaying &&
//                       !widget.videoController.value.isPlaying) {
//                     widget.videoController.play();
//                   }
//                   Get.back();
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Text(
//             _isVoiceDetected ? "Voice detected - Recording" : "Listening...",
//             style: GoogleFonts.poppins(
//               fontSize: 14,
//               color: _isVoiceDetected ? Colors.green : Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _WaveformPainter extends CustomPainter {
//   final List<double> waveformData;

//   _WaveformPainter(this.waveformData);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = AppConstants.purpleColor
//       ..style = PaintingStyle.fill;

//     final centerY = size.height / 2;
//     final barWidth = size.width / waveformData.length * 1.5;

//     for (var i = 0; i < 35; i++) {
//       final height = waveformData[i] * size.height * 0.8;
//       final left = i * barWidth;
//       final rect = Rect.fromLTRB(
//         left,
//         centerY - height / 2,
//         left + barWidth - 2,
//         centerY + height / 2,
//       );
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(rect, Radius.circular(barWidth / 4)),
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:vedalaya_app/core/themes/app_constants.dart';
// import 'package:video_player/video_player.dart';

// class MicrophoneBottomSheet extends StatefulWidget {
//   final VideoPlayerController videoController;

//   const MicrophoneBottomSheet({
//     super.key,
//     required this.videoController,
//   });

//   @override
//   State<MicrophoneBottomSheet> createState() => _MicrophoneBottomSheetState();
// }

// class _MicrophoneBottomSheetState extends State<MicrophoneBottomSheet>
//     with SingleTickerProviderStateMixin {
//   final FlutterSoundRecorder _micRecorder = FlutterSoundRecorder();
//   final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();
//   bool _isRecording = false;
//   bool _isPlaying = false;
//   String _recordFilePath = '';
//   Duration _recordDuration = Duration.zero;
//   Duration _playPosition = Duration.zero;
//   Timer? _timer;
//   Timer? _waveTimer;
//   final List<double> _waveformData = List.filled(50, 0.1);
//   int _waveformIndex = 0;
//   bool _isVoiceDetected = false;
//   final double _voiceThreshold = 0.02;
//   bool _wasVideoPlaying = false;
//   bool _showPlaySongMessage = false;
//   Duration? _recordingStartPosition;
//   bool _isProcessing = false;
//   bool _isAudioPlayerInitialized = false;
//   bool _listern = false;
//   late AnimationController _glowController;
//   late Animation<double> _glowAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _initRecorder();
//     _initAudioPlayer();
//     _startAudioMonitoring();
//     _wasVideoPlaying = widget.videoController.value.isPlaying;
//     if (!_wasVideoPlaying) {
//       setState(() {
//         _showPlaySongMessage = true;
//       });
//     }
//     _glowController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     )..repeat(reverse: true); // initially repeat, you can stop it later

//     _glowAnimation = Tween<double>(begin: 8.0, end: 20.0).animate(
//       CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
//     );
//     _glowController.stop();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _waveTimer?.cancel();
//     _micRecorder.closeRecorder();
//     _audioPlayer.closePlayer();
//     _glowController.dispose();
//     super.dispose();
//   }

//   Future<void> _initRecorder() async {
//     await _micRecorder.openRecorder();
//     _micRecorder.setSubscriptionDuration(const Duration(milliseconds: 50));
//   }

//   Future<void> _initAudioPlayer() async {
//     await _audioPlayer.openPlayer();
//     setState(() {
//       _isAudioPlayerInitialized = true;
//     });
//   }

//   void _startAudioMonitoring() {
//     _waveTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       if (_isRecording) {
//         setState(() {
//           _waveformData[_waveformIndex] = 0.2 + Random().nextDouble() * 0.8;
//           _waveformIndex = (_waveformIndex + 1) % _waveformData.length;
//           _isVoiceDetected = _waveformData[_waveformIndex] > _voiceThreshold;
//         });
//       }
//     });
//   }

//   Future<void> _startRecording() async {
//     if (!widget.videoController.value.isPlaying) {
//       setState(() {
//         _showPlaySongMessage = true;
//       });
//       return;
//     }

//     try {
//       if (await Permission.microphone.request().isGranted) {
//         final directory = await getTemporaryDirectory();
//         _recordFilePath =
//             '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

//         // Store the current position of the video/song
//         _recordingStartPosition = widget.videoController.value.position;

//         await _micRecorder.startRecorder(
//           toFile: _recordFilePath,
//           codec: Codec.aacADTS,
//         );

//         setState(() {
//           _isRecording = true;
//           _recordDuration = Duration.zero;
//           _showPlaySongMessage = false;
//           _isProcessing = false;
//         });

//         _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//           setState(() {
//             _recordDuration += const Duration(milliseconds: 100);
//           });
//         });
//       }
//     } catch (e) {
//       debugPrint('Error starting recording: $e');
//     }
//   }

//   Future<void> _stopRecording() async {
//     try {
//       await _micRecorder.stopRecorder();
//       _timer?.cancel();
//       setState(() {
//         _isRecording = false;
//       });
//     } catch (e) {
//       debugPrint('Error stopping recording: $e');
//     }
//   }

//   Future<void> _playRecording() async {
//     if (_recordFilePath.isEmpty ||
//         _recordingStartPosition == null ||
//         !_isAudioPlayerInitialized) {
//       return;
//     }

//     try {
//       setState(() {
//         _isProcessing = true;
//       });

//       // Pause the video if it's playing and store its state
//       _wasVideoPlaying = widget.videoController.value.isPlaying;
//       if (_wasVideoPlaying) {
//         await widget.videoController.pause();
//       }

//       // Seek video to the recording start position
//       await widget.videoController.seekTo(_recordingStartPosition!);

//       // Start playing the video (background music)
//       await widget.videoController.play();

//       // Start playing the recorded voice
//       await _audioPlayer.startPlayer(
//         fromURI: _recordFilePath,
//         codec: Codec.aacADTS,
//         whenFinished: () {
//           if (mounted) {
//             setState(() {
//               _isPlaying = false;
//               _playPosition = Duration.zero;
//             });
//             _stopBackgroundMusic();
//           }
//         },
//       );

//       setState(() {
//         _isPlaying = true;
//         _isProcessing = false;
//       });

//       final startTime = DateTime.now();

//       _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
//         final elapsed = DateTime.now().difference(startTime);
//         setState(() {
//           _playPosition = elapsed;
//         });

//         if (elapsed >= _recordDuration) {
//           timer.cancel();
//           _stopPlaying();
//         }
//       });
//     } catch (e) {
//       debugPrint('Error playing recording: $e');
//       setState(() {
//         _isPlaying = false;
//         _isProcessing = false;
//       });
//       _stopBackgroundMusic();
//     }
//   }

//   Future<void> _stopBackgroundMusic() async {
//     if (widget.videoController.value.isPlaying) {
//       await widget.videoController.pause();
//     }
//     if (_wasVideoPlaying) {
//       await widget.videoController.play();
//     }
//   }

//   Future<void> _stopPlaying() async {
//     _timer?.cancel();
//     try {
//       await _audioPlayer.stopPlayer();
//       await _stopBackgroundMusic();
//     } catch (e) {
//       debugPrint('Error stopping playback: $e');
//     }
//     setState(() {
//       _isPlaying = false;
//       _playPosition = Duration.zero;
//     });
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$minutes:$seconds';
//   }

//   Widget _buildWaveform() {
//     return SizedBox(
//       width: Get.width * 0.3,
//       height: 50,
//       child: CustomPaint(
//         painter: _WaveformPainter(_waveformData),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Color.fromRGBO(255, 235, 185, 1),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SizedBox(
//                 height: Get.height * 0.07,
//                 width: Get.width * 0.25,
//                 child: Text(
//                   "Record your practice",
//                   style: GoogleFonts.poppins(
//                     color: const Color.fromRGBO(30, 30, 30, 1),
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               Text(
//                 _isPlaying
//                     ? _formatDuration(_playPosition)
//                     : _formatDuration(_recordDuration),
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               _buildWaveform(),
//             ],
//           ),
//           // const SizedBox(height: 2),
//           if (_showPlaySongMessage)
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5),
//               child: Text(
//                 "Please play the song first to start recording",
//                 style: GoogleFonts.poppins(
//                   color: Colors.red,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           if (_isProcessing)
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               child: Column(
//                 children: [
//                   CircularProgressIndicator(
//                     color: AppConstants.purpleColor,
//                   ),
//                   // const SizedBox(height: 25),
//                   Text(
//                     "Preparing playback...",
//                     style: GoogleFonts.poppins(
//                       fontSize: 12,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               GestureDetector(
//                 onTap: () async {
//                   if (_recordFilePath.isEmpty ||
//                       _isProcessing ||
//                       !_isAudioPlayerInitialized) return;
//                   if (_isPlaying) {
//                     await _stopPlaying();
//                   } else {
//                     if (_listern) {
//                       return;
//                     }
//                     await _playRecording();
//                   }
//                 },
//                 child: Icon(
//                   Icons.headphones_rounded,
//                   size: 33,
//                   color: _recordFilePath.isEmpty ||
//                           _isProcessing ||
//                           !_isAudioPlayerInitialized
//                       ? Colors.grey
//                       : (_isPlaying ? AppConstants.purpleColor : Colors.black),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   if (_isProcessing) return;
//                   if (_isRecording) {
//                     _stopRecording();
//                     _glowController.stop(); // stop glowing
//                   } else {
//                     _startRecording();
//                     _glowController.repeat(reverse: true); // start glowing
//                   }
//                   setState(() {
//                     _isRecording = !_isRecording;
//                     _listern = _isRecording;
//                   });
//                 },
//                 child: AnimatedBuilder(
//                   animation: _glowAnimation,
//                   builder: (context, child) {
//                     return Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: _isRecording
//                             ? [
//                                 BoxShadow(
//                                   color:
//                                       AppConstants.purpleColor.withOpacity(0.5),
//                                   spreadRadius: _glowAnimation.value,
//                                   blurRadius: _glowAnimation.value,
//                                 ),
//                               ]

//                             : [],
//                       ),
//                       child: child,
//                     );
//                   },
//                   child: CircleAvatar(
//                     radius: 24,
//                     backgroundColor:
//                         _isProcessing ? Colors.grey : AppConstants.purpleColor,
//                     child: Center(
//                       child: Icon(
//                         _isRecording ? Icons.stop : FontAwesomeIcons.microphone,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: FaIcon(
//                   FontAwesomeIcons.check,
//                   size: 32,
//                   color: _recordFilePath.isEmpty || _isProcessing
//                       ? Colors.grey
//                       : Colors.green,
//                 ),
//                 onPressed: () {
//                   if (_recordFilePath.isEmpty || _isProcessing) return;
//                   Get.back(result: {
//                     'audioFile': File(_recordFilePath),
//                     'startPosition': _recordingStartPosition,
//                     'duration': _recordDuration,
//                   });
//                 },
//               ),
//               IconButton(
//                 icon: const FaIcon(
//                   FontAwesomeIcons.xmark,
//                   size: 32,
//                   color: Colors.red,
//                 ),
//                 onPressed: () {
//                   if (_isProcessing) return;
//                   if (_isRecording) _stopRecording();
//                   if (_isPlaying) _stopPlaying();
//                   if (_wasVideoPlaying &&
//                       !widget.videoController.value.isPlaying) {
//                     widget.videoController.play();
//                   }
//                   Get.back();
//                 },
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           Text(
//             _isVoiceDetected ? "Voice detected - Recording" : "Listening...",
//             style: GoogleFonts.poppins(
//               fontSize: 12,
//               color: _isVoiceDetected ? Colors.green : Colors.grey,
//             ),
//           ),
//           if (!_isAudioPlayerInitialized)
//             Padding(
//               padding: const EdgeInsets.only(top: 10),
//               child: Text(
//                 "Initializing audio player...",
//                 style: GoogleFonts.poppins(
//                   fontSize: 12,
//                   color: Colors.orange,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class _WaveformPainter extends CustomPainter {
//   final List<double> waveformData;

//   _WaveformPainter(this.waveformData);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = AppConstants.purpleColor
//       ..style = PaintingStyle.fill;

//     final centerY = size.height / 2;
//     final barWidth = size.width / waveformData.length * 1.5;

//     for (var i = 0; i < 35; i++) {
//       final height = waveformData[i] * size.height * 0.8;
//       final left = i * barWidth;
//       final rect = Rect.fromLTRB(
//         left,
//         centerY - height / 2,
//         left + barWidth - 2,
//         centerY + height / 2,
//       );
//       canvas.drawRRect(
//         RRect.fromRectAndRadius(rect, Radius.circular(barWidth / 4)),
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vedalaya_app/core/themes/app_constants.dart';
import 'package:vedalaya_app/utils/recording_database.dart';
import 'package:vedalaya_app/views/learning/model/recording_model.dart';

import 'package:video_player/video_player.dart';

class MicrophoneBottomSheet extends StatefulWidget {
  final VideoPlayerController videoController;

  const MicrophoneBottomSheet({
    super.key,
    required this.videoController,
  });

  @override
  State<MicrophoneBottomSheet> createState() => _MicrophoneBottomSheetState();
}

class _MicrophoneBottomSheetState extends State<MicrophoneBottomSheet>
    with SingleTickerProviderStateMixin {
  final FlutterSoundRecorder _micRecorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String _recordFilePath = '';
  Duration _recordDuration = Duration.zero;
  Duration _playPosition = Duration.zero;
  Timer? _timer;
  Timer? _waveTimer;
  final List<double> _waveformData = List.filled(50, 0.1);
  int _waveformIndex = 0;
  bool _isVoiceDetected = false;
  final double _voiceThreshold = 0.02;
  bool _wasVideoPlaying = false;
  bool _showPlaySongMessage = false;
  Duration? _recordingStartPosition;
  bool _isProcessing = false;
  bool _isAudioPlayerInitialized = false;
  bool _listern = false;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  bool _isPaused = false;
  Duration _pausedDuration = Duration.zero;
  DateTime? _recordingStartTime;
  Duration? _playbackStartVideoPosition;
  Duration? _playbackPausePosition;
  final RecordingDatabase _database = RecordingDatabase.instance;
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initRecorder();
    _initAudioPlayer();
    _startAudioMonitoring();
    _wasVideoPlaying = widget.videoController.value.isPlaying;
    if (!_wasVideoPlaying) {
      setState(() {
        _showPlaySongMessage = true;
      });
    }
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 8.0, end: 20.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _glowController.stop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _waveTimer?.cancel();
    _micRecorder.closeRecorder();
    _audioPlayer.closePlayer();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _initRecorder() async {
    await _micRecorder.openRecorder();
    _micRecorder.setSubscriptionDuration(const Duration(milliseconds: 50));
  }

  Future<void> _initAudioPlayer() async {
    await _audioPlayer.openPlayer();
    setState(() {
      _isAudioPlayerInitialized = true;
    });
  }

  void _startAudioMonitoring() {
    _waveTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isRecording) {
        setState(() {
          _waveformData[_waveformIndex] = 0.2 + Random().nextDouble() * 0.8;
          _waveformIndex = (_waveformIndex + 1) % _waveformData.length;
          _isVoiceDetected = _waveformData[_waveformIndex] > _voiceThreshold;
        });
      }
    });
  }

  Future<void> _startRecording() async {
    if (!widget.videoController.value.isPlaying) {
      setState(() {
        _showPlaySongMessage = true;
      });
      return;
    }

    try {
      if (await Permission.microphone.request().isGranted) {
        if (_isPaused) {
          // Resume recording
          await _micRecorder.resumeRecorder();
          _recordingStartTime = DateTime.now().subtract(_pausedDuration);
        } else {
          // Start new recording
          final directory = await getTemporaryDirectory();
          _recordFilePath =
              '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';
          _recordingStartPosition = widget.videoController.value.position;
          _recordingStartTime = DateTime.now();
          await _micRecorder.startRecorder(
            toFile: _recordFilePath,
            codec: Codec.aacADTS,
          );
        }

        setState(() {
          _isRecording = true;
          _isPaused = false;
          _showPlaySongMessage = false;
          _isProcessing = false;
        });

        _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
          setState(() {
            _recordDuration = DateTime.now().difference(_recordingStartTime!);
          });
        });
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> _pauseRecording() async {
    try {
      await _micRecorder.pauseRecorder();
      _timer?.cancel();
      setState(() {
        _isRecording = false;
        _isPaused = true;
        _pausedDuration = _recordDuration;
      });
    } catch (e) {
      debugPrint('Error pausing recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _micRecorder.stopRecorder();
      _timer?.cancel();
      setState(() {
        _isRecording = false;
        _isPaused = false;
        _pausedDuration = Duration.zero;
      });
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  Future<void> _playRecording() async {
    if (_recordFilePath.isEmpty ||
        _recordingStartPosition == null ||
        !_isAudioPlayerInitialized) {
      return;
    }

    try {
      setState(() {
        _isProcessing = true;
      });

      // Store current video state and position if not already stored
      if (_playbackPausePosition == null) {
        _wasVideoPlaying = widget.videoController.value.isPlaying;
        _playbackPausePosition = widget.videoController.value.position;
      }

      // Pause the video if it's playing
      if (widget.videoController.value.isPlaying) {
        await widget.videoController.pause();
      }

      // Start playing the recorded voice
      await _audioPlayer.startPlayer(
        fromURI: _recordFilePath,
        codec: Codec.aacADTS,
        whenFinished: () async {
          if (mounted) {
            setState(() {
              _isPlaying = false;
              _playPosition = Duration.zero;
            });

            // Resume background music if it was playing
            if (_wasVideoPlaying && _playbackPausePosition != null) {
              await widget.videoController.seekTo(_playbackPausePosition!);
              await widget.videoController.play();
            }
            _playbackPausePosition = null;
          }
        },
      );

      setState(() {
        _isPlaying = true;
        _isProcessing = false;
      });

      final startTime = DateTime.now();

      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        final elapsed = DateTime.now().difference(startTime);
        setState(() {
          _playPosition = elapsed;
        });

        if (elapsed >= _recordDuration) {
          timer.cancel();
          _stopPlaying();
        }
      });
    } catch (e) {
      debugPrint('Error playing recording: $e');
      setState(() {
        _isPlaying = false;
        _isProcessing = false;
      });
      // Resume background music if it was playing
      if (_wasVideoPlaying && _playbackPausePosition != null) {
        await widget.videoController.seekTo(_playbackPausePosition!);
        await widget.videoController.play();
      }
      _playbackPausePosition = null;
    }
  }

  Future<void> _stopPlaying() async {
    _timer?.cancel();
    try {
      await _audioPlayer.stopPlayer();
      // Resume background music if it was playing
      if (_wasVideoPlaying && _playbackPausePosition != null) {
        await widget.videoController.seekTo(_playbackPausePosition!);
        await widget.videoController.play();
      }
      _playbackPausePosition = null;
    } catch (e) {
      debugPrint('Error stopping playback: $e');
    }
    setState(() {
      _isPlaying = false;
      _playPosition = Duration.zero;
    });
  }

  Future<void> _handlePlayback() async {
    if (_recordFilePath.isEmpty ||
        _isProcessing ||
        !_isAudioPlayerInitialized) {
      return;
    }

    if (_isPlaying) {
      await _stopPlaying();
    } else {
      if (_isRecording) {
        // Pause recording first
        await _pauseRecording();
        _glowController.stop();
      }
      await _playRecording();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildWaveform() {
    return SizedBox(
      width: Get.width * 0.3,
      height: 50,
      child: CustomPaint(
        painter: _WaveformPainter(_waveformData),
      ),
    );
  }

  Future<void> _saveRecording() async {
    if (_recordFilePath.isEmpty || _recordingStartPosition == null) return;

    final now = DateTime.now();
    final defaultTitle = 'Recording ${now.day}/${now.month}/${now.year}';

    // Show dialog to get recording title
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Save Recording'),
        content: TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: defaultTitle,
            labelText: 'Recording Title',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(
              context,
              _titleController.text.trim().isEmpty
                  ? defaultTitle
                  : _titleController.text.trim(),
            ),
            child: Text('Save'),
          ),
        ],
      ),
    );

    if (title != null) {
      final recording = Recording(
        title: title,
        voicePath: _recordFilePath,
        backgroundPosition: _recordingStartPosition!,
        duration: _recordDuration,
        createdAt: DateTime.now(),
      );

      await _database.createRecording(recording);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recording saved successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 235, 185, 1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: Get.height * 0.07,
                width: Get.width * 0.25,
                child: Text(
                  "Record your practice",
                  style: GoogleFonts.poppins(
                    color: const Color.fromRGBO(30, 30, 30, 1),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                _isPlaying
                    ? _formatDuration(_playPosition)
                    : _formatDuration(_recordDuration),
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              _buildWaveform(),
            ],
          ),
          if (_showPlaySongMessage)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "Please play the song first to start recording",
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (_isProcessing)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  CircularProgressIndicator(
                    color: AppConstants.purpleColor,
                  ),
                  Text(
                    "Preparing playback...",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: _handlePlayback,
                child: Icon(
                  Icons.headphones_rounded,
                  size: 33,
                  color: _recordFilePath.isEmpty ||
                          _isProcessing ||
                          !_isAudioPlayerInitialized
                      ? Colors.grey
                      : (_isPlaying ? AppConstants.purpleColor : Colors.black),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_isProcessing) return;
                  if (_isRecording) {
                    _pauseRecording();
                    _glowController.stop();
                  } else if (_isPaused) {
                    _startRecording();
                    _glowController.repeat(reverse: true);
                  } else {
                    _startRecording();
                    _glowController.repeat(reverse: true);
                  }
                  setState(() {
                    _listern = _isRecording || _isPaused;
                  });
                },
                child: AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: _isRecording
                            ? [
                                BoxShadow(
                                  color:
                                      AppConstants.purpleColor.withOpacity(0.5),
                                  spreadRadius: _glowAnimation.value,
                                  blurRadius: _glowAnimation.value,
                                ),
                              ]
                            : [],
                      ),
                      child: child,
                    );
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor:
                        _isProcessing ? Colors.grey : AppConstants.purpleColor,
                    child: Center(
                      child: Icon(
                        _isRecording
                            ? Icons.pause
                            : (_isPaused
                                ? Icons.mic
                                : FontAwesomeIcons.microphone),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              // Add this to your existing MicrophoneBottomSheet class

              IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.check,
                    size: 32,
                    color: _recordFilePath.isEmpty || _isProcessing
                        ? Colors.grey
                        : Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      _saveRecording();
                    });
                  }),
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.xmark,
                  size: 32,
                  color: Colors.red,
                ),
                onPressed: () {
                  if (_isProcessing) return;
                  if (_isRecording) _stopRecording();
                  if (_isPlaying) _stopPlaying();
                  if (_wasVideoPlaying &&
                      !widget.videoController.value.isPlaying) {
                    widget.videoController.play();
                  }
                  Get.back();
                },
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            _isVoiceDetected ? "Voice detected - Recording" : "Listening...",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: _isVoiceDetected ? Colors.green : Colors.grey,
            ),
          ),
          if (!_isAudioPlayerInitialized)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "Initializing audio player...",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.orange,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> waveformData;

  _WaveformPainter(this.waveformData);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppConstants.purpleColor
      ..style = PaintingStyle.fill;

    final centerY = size.height / 2;
    final barWidth = size.width / waveformData.length * 1.5;

    for (var i = 0; i < 35; i++) {
      final height = waveformData[i] * size.height * 0.8;
      final left = i * barWidth;
      final rect = Rect.fromLTRB(
        left,
        centerY - height / 2,
        left + barWidth - 2,
        centerY + height / 2,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(barWidth / 4)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
