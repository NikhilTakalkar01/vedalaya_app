import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;
  final bool isMusic;
  final bool showBackwardIcon;
  final bool showForwardIcon;
  final bool isFullScreen;

  const VideoPlayerWidget({
    super.key,
    required this.controller,
    required this.isMusic,
    required this.showBackwardIcon,
    required this.showForwardIcon,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(isFullScreen ? 0 : 12),
      child: isMusic
          ? Image.asset(
              "assets/icons/hanuman.png",
              fit: BoxFit.cover,
              height: isFullScreen ? Get.height : Get.height * 0.66,
              width: isFullScreen ? Get.width : Get.width * 0.9,
            )
          : controller.value.isInitialized
              ? isFullScreen
                  ? AspectRatio(
                      aspectRatio: 8 / 15.5,
                      child: VideoPlayer(controller),
                    )
                  : FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        height: Get.height * 0.66,
                        width: Get.width * 0.9,
                        child: VideoPlayer(controller),
                      ),
                    )
              : Container(
                  color: isFullScreen ? Colors.black : Colors.grey,
                  height: isFullScreen ? Get.height : Get.height * 0.66,
                  width: isFullScreen ? Get.width : Get.width * 0.9,
                  child: const Center(child: CircularProgressIndicator()),
                ),
    );
  }
}
