
import 'package:flutter/material.dart';

class LanguageSelectionDialog extends StatelessWidget {
  final List<String> languages = [
    'English',
    'हिंदी',
    'বাংলা',
    'தமிழ்',
    'తెలుగు',
    'മലയാളം',
    'मराठी',
    'ગુજરાતી',
    'ಕನ್ನಡ',
    'No Subtitle',
  ];

  final int selectedIndex = 6;

  LanguageSelectionDialog({super.key}); // Index for 'हिंदी'

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Language',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5E0B99), // Purple shade
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(languages.length, (index) {
              final isSelected = index == selectedIndex;
              return InkWell(
                onTap: () {
                  
                  Navigator.of(context).pop(languages[index]);
                },
                child: Container(
                  width: double.infinity,
                  color: isSelected ? Color(0xFFD6B9F3) : Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(
                    languages[index],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
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
