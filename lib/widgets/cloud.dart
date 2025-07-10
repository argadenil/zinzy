import 'package:flutter/material.dart';

class AnimatedClouds extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;

  const AnimatedClouds({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<AnimatedClouds> createState() => _AnimatedCloudsState();
}

class _AnimatedCloudsState extends State<AnimatedClouds>
    with TickerProviderStateMixin {
  late final List<AnimationController> controllers;
  late final List<Animation<Offset>> animations;

  @override
  void initState() {
    super.initState();

    controllers = List.generate(3, (index) {
      return AnimationController(
        vsync: this,
        duration: Duration(seconds: 12 + index * 3),
      )..repeat();
    });

    animations = List.generate(3, (index) {
      return Tween<Offset>(
        begin: Offset(-1.5, 0.05 + index * 0.15),
        end: Offset(1.5, 0.05 + index * 0.15),
      ).animate(
        CurvedAnimation(parent: controllers[index], curve: Curves.linear),
      );
    });
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(3, (index) {
        return SlideTransition(
          position: animations[index],
          child: Padding(
            padding: EdgeInsets.only(
              top: widget.screenHeight * (0.05 + index * 0.15),
            ),
            child: SizedBox(
              width: 300,
              height: 360,
              child: Image.asset(
                'assets/images/cloud.png',
                fit: BoxFit.contain,
              ), // use your cloud image
            ),
          ),
        );
      }),
    );
  }
}
