import 'package:flutter/material.dart';

class ForceScreen extends StatefulWidget {
  const ForceScreen({super.key});

  @override
  State<ForceScreen> createState() => _ForceScreenState();
}

class _ForceScreenState extends State<ForceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFBB2D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/images/back_button.webp',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
