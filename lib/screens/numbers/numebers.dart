import 'package:flutter/material.dart';
import 'package:zinzy/widgets/cloud.dart';

class NumbersScreen extends StatelessWidget {
  const NumbersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFffbb2d),
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedClouds(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(42),
                ),
                color: Color(0xfff36a1a),
                elevation: 6,
                child: Container(
                  height: screenWidth * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
