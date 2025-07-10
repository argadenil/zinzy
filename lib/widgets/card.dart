import 'package:flutter/material.dart';

Widget buildUniformCard({
  required Widget content,
  required String label,
  required Color backgroundColor,
  required Color borderColor,
  required double fontSize,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(42)),
      color: backgroundColor,
      elevation: 6,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: borderColor, width: 7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: FittedBox(fit: BoxFit.scaleDown, child: content),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Color(0xfffffcc9),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
