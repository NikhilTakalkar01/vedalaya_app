import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SubtitleDisplay extends StatelessWidget {
  final String currentSubtitle;

  const SubtitleDisplay({super.key, required this.currentSubtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          fontSize: Get.width * 0.045,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}