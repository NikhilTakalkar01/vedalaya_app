
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChapterSelectionDialog extends StatelessWidget {
  final int currentChapterIndex;
  final List<bool> chapterCompletionStatus; // true = completed, false = locked
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Hanuman Chalisa',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5E0B99),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(chapterNames.length, (index) {
              final isCompleted = chapterCompletionStatus[index];
              final isCurrent = index == currentChapterIndex;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${index + 1}. ${chapterNames[index]}",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight:
                            isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: isCurrent ? Colors.black : Colors.black54,
                      ),
                    ),
                    if (isCompleted)
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 18)
                    else if (isCurrent)
                      const Icon(Icons.circle,
                          color: Color(0xFF5E0B99), size: 14)
                    else
                      const Icon(Icons.lock, color: Colors.red, size: 18),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
