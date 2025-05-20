import 'package:flutter/material.dart';
import 'package:vedalaya_app/core/themes/app_constants.dart';
import 'package:video_player/video_player.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final VideoPlayerController controller;
  final VoidCallback onToggleFullScreen;
  final bool isFullScreen;

  const ProgressIndicatorWidget({
    super.key,
    required this.controller,
    required this.onToggleFullScreen,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Slider(
            min: 0,
            max: controller.value.duration.inSeconds.toDouble(),
            value: controller.value.position.inSeconds
                .clamp(0, controller.value.duration.inSeconds)
                .toDouble(),
            onChanged: (value) {
              final seekTo = Duration(seconds: value.toInt());
              controller.seekTo(seekTo);
            },
            activeColor: Colors.purple,
            inactiveColor: Colors.grey,
          ),
        ),
        GestureDetector(
          onTap: onToggleFullScreen,
          child: Icon(
            isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
            size: 35,
            color: AppConstants.purpleColor,
          ),
        ),
      ],
    );
  }
}
