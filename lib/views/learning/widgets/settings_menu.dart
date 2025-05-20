import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vedalaya_app/core/themes/app_constants.dart';
import 'package:vedalaya_app/views/learning/modules/language_selection.dart';

class SettingsMenu extends StatelessWidget {
  final double playbackSpeed;
  final bool autoRepeat;
  final bool isMusic;
  final VoidCallback onToggleAutoRepeat;
  final VoidCallback onToggleMode;
  final VoidCallback onShowSpeedSelector;
  final VoidCallback onClose;
  final bool isFullScreen;

  const SettingsMenu({
    super.key,
    required this.playbackSpeed,
    required this.autoRepeat,
    required this.isMusic,
    required this.onToggleAutoRepeat,
    required this.onToggleMode,
    required this.onShowSpeedSelector,
    required this.onClose,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: isFullScreen ? 60 : 120,
      right: isFullScreen ? 30 : 40,
      child: Container(
        padding: const EdgeInsets.only(bottom: 5),
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
              value: "${playbackSpeed}x",
              icon: "assets/icons/Vector (7).svg",
              onTap: onShowSpeedSelector,
            ),
            _buildMenuSection(
              title: "Auto Repeat",
              value: "",
              icon: "assets/icons/Vector (9).svg",
              isToggle: true,
              toggleValue: autoRepeat,
              onTap: onToggleAutoRepeat,
            ),
            _buildMenuSection(
              title: isMusic ? "Video" : "Audio",
              value: "",
              icon:
                  isMusic ? "assets/icons/video.svg" : "assets/icons/music.svg",
              onTap: onToggleMode,
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
                SvgPicture.asset(icon),
                // _iconBox(icon),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(30, 30, 30, 1)),
                ),
              ],
            ),
            if (value.isNotEmpty)
              Row(
                children: [
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color.fromRGBO(30, 30, 30, 0.9)),
                  ),
                  const Icon(Icons.keyboard_arrow_right_outlined)
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

  Widget _iconBox(String svgPath) {
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
