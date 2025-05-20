import 'package:flutter/material.dart';

class SpeedDialog extends StatelessWidget {
  final double currentSpeed;
  final List<double> speeds;
  final ValueChanged<double> onSpeedSelected;

  const SpeedDialog({
    super.key,
    required this.currentSpeed,
    required this.speeds,
    required this.onSpeedSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              final isSelected = speed == currentSpeed;
              return GestureDetector(
                onTap: () {
                  onSpeedSelected(speed);
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFD6B9F3) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${speed}x",
                    style: TextStyle(
                      color: isSelected ? Colors.purple : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
  }
}