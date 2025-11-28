import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberTracingScreen extends StatefulWidget {
  final int number;
  const NumberTracingScreen({super.key, required this.number});

  @override
  State<NumberTracingScreen> createState() => _NumberTracingScreenState();
}

class _NumberTracingScreenState extends State<NumberTracingScreen>
    with SingleTickerProviderStateMixin {
  List<Offset?> points = [];

  late ConfettiController _confettiController;
  late AnimationController _glowController;

  bool isCompleted = false;
  double accuracy = 0;

  @override
  void initState() {
    super.initState();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
      lowerBound: 0.4,
      upperBound: 1.0,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _reset() {
    setState(() {
      points.clear();
      isCompleted = false;
      accuracy = 0;
    });
    _glowController.repeat();
  }

  void _markCompleted() {
    if (isCompleted) return;

    setState(() {
      accuracy = 100;
      isCompleted = true;
    });

    _glowController.stop();
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    final numberText = widget.number.toString();

    return Scaffold(
      backgroundColor: const Color(0xFFFFB938),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ✅ THIS PART IS THE MAIN FIX: FULLSCREEN LISTENER
            Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (details) {
                setState(() {
                  points.add(details.localPosition);
                });
              },
              onPointerMove: (details) {
                setState(() {
                  points.add(details.localPosition);
                });

                if (points.length > 200) {
                  _markCompleted();
                }
              },
              onPointerUp: (_) {
                points.add(null);
              },
              child: CustomPaint(
                painter: TracingPainter(points),
                size: Size.infinite,
              ),
            ),

            /// Glow number
            Center(
              child: AnimatedBuilder(
                animation: _glowController,
                builder: (_, __) {
                  return Text(
                    numberText,
                    style: GoogleFonts.baloo2(
                      fontSize: 360,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(
                        isCompleted ? _glowController.value : 0.25,
                      ),
                    ),
                  );
                },
              ),
            ),

            /// Confetti
            IgnorePointer(
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.1,
                numberOfParticles: 60,
                maxBlastForce: 40,
                minBlastForce: 20,
                gravity: 0.3,
              ),
            ),

            /// Accuracy badge
            if (isCompleted)
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "Accuracy: ${accuracy.toInt()}%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            /// Back
            Positioned(
              top: 12,
              left: 12,
              child: _circleButton(Icons.arrow_back, () {
                Navigator.pop(context);
              }),
            ),

            /// Bottom nav
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleButton(Icons.arrow_back, () {
                    if (widget.number > 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NumberTracingScreen(
                              number: widget.number - 1),
                        ),
                      );
                    }
                  }),
                  _circleButton(Icons.refresh, _reset),
                  _circleButton(Icons.arrow_forward, () {
                    if (widget.number < 9) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NumberTracingScreen(
                              number: widget.number + 1),
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(icon, size: 32, color: Colors.black),
      ),
    );
  }
}

class TracingPainter extends CustomPainter {
  final List<Offset?> points;
  TracingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 26
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];

      if (p1 != null && p2 != null) {
        canvas.drawLine(p1, p2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(TracingPainter oldDelegate) => true;
}
