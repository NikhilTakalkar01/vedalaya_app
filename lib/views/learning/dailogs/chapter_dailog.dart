import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vedalaya_app/core/themes/app_constants.dart';

class ChapterSelectionDialog extends StatelessWidget {
  final int currentChapterIndex;
  final List<bool> chapterCompletionStatus;
  final List<String> chapterNames;

  const ChapterSelectionDialog({
    super.key,
    required this.currentChapterIndex,
    required this.chapterCompletionStatus,
    required this.chapterNames,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Chapter",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.purpleColor,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(chapterNames.length, (index) {
              final isCompleted = chapterCompletionStatus[index];
              final isCurrent = index == currentChapterIndex;
              return InkWell(
                onTap: () {
                  Navigator.of(context).pop(index);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCurrent 
                              ? AppConstants.purpleColor
                              : isCompleted
                                  ? Colors.green
                                  : Colors.grey[300],
                        ),
                        child: isCurrent
                            ? const Icon(Icons.play_arrow, color: Colors.white, size: 14)
                            : isCompleted
                                ? const Icon(Icons.check, color: Colors.white, size: 14)
                                : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "${index + 1}. ${chapterNames[index]}",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: isCurrent ? AppConstants.purpleColor : Colors.black,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}