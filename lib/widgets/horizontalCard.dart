import 'package:flutter/material.dart';

class HorizontalLearningCard extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color borderColor;

  const HorizontalLearningCard({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Horizontal width
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(40),
        border: Border(
          top: BorderSide(color: borderColor, width: 8),
          left: BorderSide(color: borderColor, width: 8),
          right: BorderSide(color: borderColor, width: 8),
          bottom: BorderSide.none,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xfffffcc9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
