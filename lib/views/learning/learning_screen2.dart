import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vedalaya_app/core/themes/app_constants.dart';
import 'package:vedalaya_app/views/learning/controller/share_option.dart';
import 'package:vedalaya_app/views/learning/dailogs/chapter_dailog.dart';
import 'package:vedalaya_app/views/learning/widgets/custom_progressbar.dart';
import 'package:vedalaya_app/views/learning/widgets/recording.dart';
import 'package:vedalaya_app/views/learning/widgets/recording_list_screen.dart';
import 'package:vedalaya_app/views/learning/widgets/video_player.dart';
import 'package:vedalaya_app/views/learning/widgets/controls.dart';
import 'package:vedalaya_app/views/learning/widgets/progress_indicator.dart';
import 'package:vedalaya_app/views/learning/widgets/settings_menu.dart';
import 'package:vedalaya_app/views/learning/widgets/subtitle_display.dart';
import 'package:video_player/video_player.dart';

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
  void dispose() {
    _videoController.removeListener(_videoListener);
    _videoController.dispose();
    _hideControlsTimer?.cancel();
    _endDialogTimer?.cancel();
    _subtitleTimer?.cancel();
    super.dispose();
  }

  void _videoListener() {
    if (!_videoController.value.isInitialized) return;

    if (_videoController.value.position >= _videoController.value.duration &&
        !_isVideoEnded &&
        _videoController.value.duration > Duration.zero) {
      setState(() => _isVideoEnded = true);
      if (_autoRepeat) {
        _replayVideo();
      } else {
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
    int countdown = 5; // Changed from 2 to 5 seconds

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Start the timer when dialog is shown
        _endDialogTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (countdown > 0) {
            setState(() => countdown--);
          } else {
            timer.cancel();
            Navigator.of(context, rootNavigator: true).pop();
            _replayVideo();
          }
        });

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
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
                  "How much is this chapter helpful?",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Why?",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _endDialogTimer?.cancel();
                        Navigator.of(context, rootNavigator: true).pop();
                        _replayVideo();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.purpleColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        "Replay",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _endDialogTimer?.cancel();
                        Navigator.of(context, rootNavigator: true).pop();
                        _replayVideo();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        "Continue",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _replayVideo() {
    setState(() => _isVideoEnded = false);
    _videoController
      ..seekTo(Duration.zero)
      ..play();
  }

  void _showMicrophoneBottomSheet(BuildContext context) {
    // Store current subtitle position
    final currentPosition = _videoController.value.position;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        // Find current subtitle text
        String subtitleText = "";
        for (final subtitle in subtitles) {
          if (currentPosition >= subtitle.start &&
              currentPosition <= subtitle.end) {
            subtitleText = subtitle.text;
            break;
          }
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Centered subtitle display
            if (subtitleText.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subtitleText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            // Microphone bottomsheet
            MicrophoneBottomSheet(videoController: _videoController),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _isFullScreen ? _buildFullScreen(context) : _buildNormalScreen(context),
        if (!_isFullScreen || (_isFullScreen && _showControls))
          Positioned(
            left: Get.width * 0.48 - 22,
            child: GestureDetector(
              onTap: () => _showMicrophoneBottomSheet(context),
              child: AnimatedContainer(
                height: _isFullScreen ? Get.height * 1.58 : Get.height * 1.7,
                duration: Duration(milliseconds: 300),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: AppConstants.purpleColor,
                  child: Center(
                    child: FaIcon(FontAwesomeIcons.microphone,
                        color: Colors.white, size: 30),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNormalScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9EE),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header and progress bar
                      _buildHeader(),
                      const SizedBox(height: 10),
                      // Video player area
                      SizedBox(
                        height: Get.height * 0.66,
                        width: Get.width * 0.9,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showControls = !_showControls;
                              _showMenu = false;
                            });
                            if (!isPause) _startHideControlsTimer();
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Video/Image content
                              VideoPlayerWidget(
                                controller: _videoController,
                                isMusic: isMusic,
                                showBackwardIcon: _showBackwardIcon,
                                showForwardIcon: _showForwardIcon,
                              ),
                              if (_showBackwardIcon)
                                const FaIcon(FontAwesomeIcons.backward,
                                    size: 50, color: Colors.white),
                              if (_showForwardIcon)
                                const FaIcon(FontAwesomeIcons.forward,
                                    size: 50, color: Colors.white),
                              // Controls
                              if (_showControls) ...[
                                ControlsWidget(
                                  isPause: isPause,
                                  onTogglePlayPause: _togglePlayPause,
                                  onBackward: _backward,
                                  onForward: _forward,
                                  onToggleMenu: _toggleMenu,
                                  onChapterDialog: () =>
                                      _showChapterDialog(context),
                                ),
                              ],
                              Positioned(
                                bottom: 70,
                                left: 20,
                                right: 20,
                                child: SubtitleDisplay(
                                    currentSubtitle: currentSubtitle),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                right: 10,
                                child: ProgressIndicatorWidget(
                                  controller: _videoController,
                                  onToggleFullScreen: _toggleFullScreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  if (_showMenu)
                    SettingsMenu(
                      playbackSpeed: _playbackSpeed,
                      autoRepeat: _autoRepeat,
                      isMusic: isMusic,
                      onToggleAutoRepeat: () =>
                          setState(() => _autoRepeat = !_autoRepeat),
                      onToggleMode: _toggleMode,
                      onShowSpeedSelector: () => _showSpeedSelector(context),
                      onClose: _toggleMenu,
                    ),
                  Positioned(
                      // top: 500,
                      // left: 400,
                      left: Get.width * 0.7,
                      top: Get.height * 0.77,
                      child: Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(RecordingsScreen());
                              },
                              icon: Icon(
                                Icons.mic,
                                size: 24,
                              )),
                          Text(
                            "Recordings",
                            style: GoogleFonts.poppins(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          )
                        ],
                      )),
                  // Share option positioned on the left
                  Positioned(
                    left: Get.width * 0.17,
                    top: Get.height * 0.77,
                    child: ShareOption(
                      chapterName: "Hanuman Chalisa",
                      // serverThumbnailUrl: "https://your-server.com/thumbnail.jpg", // Enable when ready
                    ),
                  ),
                  // Recordings option positioned on the right
                  Positioned(
                      top: Get.height * 0.86,
                      left: Get.width * 0.37,
                      child: Text(
                        "Start Recording",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(139, 139, 139, 1)),
                      ))
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFullScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
            _showMenu = false;
          });
          if (!isPause) _startHideControlsTimer();
        },
        child: Stack(
          children: [
            Center(
              child: VideoPlayerWidget(
                controller: _videoController,
                isMusic: isMusic,
                showBackwardIcon: _showBackwardIcon,
                showForwardIcon: _showForwardIcon,
                isFullScreen: true,
              ),
            ),
            if (_showControls) ...[
              ControlsWidget(
                isPause: isPause,
                onTogglePlayPause: _togglePlayPause,
                onBackward: _backward,
                onForward: _forward,
                onToggleMenu: _toggleMenu,
                onChapterDialog: () => _showChapterDialog(context),
                isFullScreen: true,
              ),
            ],
            Positioned(
              bottom: 160,
              left: 20,
              right: 20,
              child: SubtitleDisplay(currentSubtitle: currentSubtitle),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: ProgressIndicatorWidget(
                controller: _videoController,
                onToggleFullScreen: _toggleFullScreen,
                isFullScreen: true,
              ),
            ),
            if (_showMenu)
              SettingsMenu(
                playbackSpeed: _playbackSpeed,
                autoRepeat: _autoRepeat,
                isMusic: isMusic,
                onToggleAutoRepeat: () =>
                    setState(() => _autoRepeat = !_autoRepeat),
                onToggleMode: _toggleMode,
                onShowSpeedSelector: () => _showSpeedSelector(context),
                onClose: _toggleMenu,
                isFullScreen: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.keyboard_arrow_left, size: 30),
            SizedBox(width: Get.width * 0.22),
            Text("Hanuman Chalisa",
                style: GoogleFonts.poppins(
                  fontSize: Get.width * 0.045,
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
                style: GoogleFonts.poppins(fontSize: Get.width * 0.035)),
          ],
        ),
      ],
    );
  }

  // Other methods remain the same...

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
}

class Subtitle {
  final Duration start;
  final Duration end;
  final String text;

  Subtitle(this.start, this.end, this.text);
}