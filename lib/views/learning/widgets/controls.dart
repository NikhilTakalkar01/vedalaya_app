// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ControlsWidget extends StatelessWidget {
//   final bool isPause;
//   final VoidCallback onTogglePlayPause;
//   final VoidCallback onBackward;
//   final VoidCallback onForward;
//   final VoidCallback onToggleMenu;
//   final VoidCallback onChapterDialog;
//   final bool isFullScreen;

//   const ControlsWidget({
//     super.key,
//     required this.isPause,
//     required this.onTogglePlayPause,
//     required this.onBackward,
//     required this.onForward,
//     required this.onToggleMenu,
//     required this.onChapterDialog,
//     this.isFullScreen = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Top controls (chapter and menu)
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             GestureDetector(
//               onTap: onChapterDialog,
//               child: Container(
//                 width: Get.width * 0.42,
//                 height: Get.height * 0.03,
//                 decoration: BoxDecoration(
//                   color: const Color.fromRGBO(30, 30, 30, 0.5),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 alignment: Alignment.center,
//                 child: Text("2. Glory of Hanuman",
//                     style: GoogleFonts.poppins(
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white,
//                       fontSize: Get.width * 0.035,
//                     )),
//               ),
//             ),
//             GestureDetector(
//               onTap: onToggleMenu,
//               child: _iconBox("assets/icons/Vector (8).svg"),
//             ),
//           ],
//         ),
//         // Center play controls
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: onBackward,
//               child: const FaIcon(
//                 FontAwesomeIcons.backwardStep,
//                 color: Colors.white,
//                 size: 30,
//               ),
//             ),
//             SizedBox(width: isFullScreen ? Get.width * 0.2 : 50),
//             GestureDetector(
//               onTap: onTogglePlayPause,
//               child: FaIcon(
//                 isPause ? FontAwesomeIcons.play : FontAwesomeIcons.pause,
//                 color: Colors.white,
//                 size: 30,
//               ),
//             ),
//             SizedBox(width: isFullScreen ? Get.width * 0.2 : 50),
//             GestureDetector(
//               onTap: onForward,
//               child: const FaIcon(
//                 FontAwesomeIcons.forwardStep,
//                 color: Colors.white,
//                 size: 30,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _iconBox(String svgPath) {
//     return Container(
//       height: Get.height * 0.030,
//       width: Get.width * 0.075,
//       padding: EdgeInsets.all(Get.width * 0.015),
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ControlsWidget extends StatelessWidget {
  final bool isPause;
  final VoidCallback onTogglePlayPause;
  final VoidCallback onBackward;
  final VoidCallback onForward;
  final VoidCallback onToggleMenu;
  final VoidCallback onChapterDialog;
  final bool isFullScreen;

  const ControlsWidget({
    super.key,
    required this.isPause,
    required this.onTogglePlayPause,
    required this.onBackward,
    required this.onForward,
    required this.onToggleMenu,
    required this.onChapterDialog,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top controls (chapter and menu)
        Positioned(
          top: isFullScreen ? 30 : 12,
          left: 10,
          right: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onChapterDialog,
                child: Container(
                  width: Get.width * (isFullScreen ? 0.5 : 0.42),
                  height: Get.height * 0.03,
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
                      fontSize: Get.width * 0.035,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onToggleMenu,
                child: _iconBox("assets/icons/Vector (8).svg"),
              ),
            ],
          ),
        ),
        // Center play controls - positioned in the middle
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onBackward,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: const FaIcon(
                    FontAwesomeIcons.backwardStep,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(width: isFullScreen ? Get.width * 0.1 : 40),
              GestureDetector(
                onTap: onTogglePlayPause,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    isPause ? FontAwesomeIcons.play : FontAwesomeIcons.pause,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ),
              SizedBox(width: isFullScreen ? Get.width * 0.1 : 40),
              GestureDetector(
                onTap: onForward,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: const FaIcon(
                    FontAwesomeIcons.forwardStep,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _iconBox(String svgPath) {
    return Container(
      height: Get.height * 0.030,
      width: Get.width * 0.075,
      padding: EdgeInsets.all(Get.width * 0.015),
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
