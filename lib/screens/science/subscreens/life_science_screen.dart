import 'package:flutter/material.dart';

class LifeScienceScreen extends StatefulWidget {
  const LifeScienceScreen({super.key});

  @override
  State<LifeScienceScreen> createState() => _LifeScienceScreenState();
}

class _LifeScienceScreenState extends State<LifeScienceScreen> {
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
