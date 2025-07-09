import 'package:flutter/material.dart';

class LearningCard extends StatelessWidget {
  final String title;
  final Widget icon;
  final Color backgroundColor;
  final Color borderColor;

  const LearningCard({
    super.key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(42)),
      color: backgroundColor,
      elevation: 6,
      child: Container(
        margin: const EdgeInsets.all(0), // Creates spacing for inner border
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: borderColor, // Inner border color
            width: 7,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 100, width: 100, child: icon),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
