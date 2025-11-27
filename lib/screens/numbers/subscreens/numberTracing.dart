import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';

class NumberTracingScreen extends StatefulWidget {
  final int number;
  const NumberTracingScreen({super.key, required this.number});

  @override
  State<NumberTracingScreen> createState() => _NumberTracingScreenState();
}

class _NumberTracingScreenState extends State<NumberTracingScreen>
    with SingleTickerProviderStateMixin {
  List<Offset?> points = [];
  bool isCompleted = false;

  late ConfettiController _confettiController;
  late AnimationController _glowController;

  double buttonScale = 1;

  /// Accuracy system
  List<Offset> targetShape = [];
  double accuracy = 0.0;

  @override
  void initState() {
    super.initState();

    /// Confetti
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    /// Glow animation
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
      lowerBound: 0.45,
      upperBound: 1.0,
    )..repeat(reverse: true);

    /// Create number outline
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateTargetShape(widget.number);
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  // ---------------------- RESET ----------------------
  void _reset() {
    setState(() {
      points.clear();
      isCompleted = false;
      accuracy = 0;
    });
    _glowController.repeat();
  }

  // ---------------------- COMPLETE ----------------------
  void _markCompleted() {
    accuracy = _calculateAccuracy();

    setState(() => isCompleted = true);

    _confettiController.play();
    _glowController.stop();
  }

  // =====================================================
  //                ACCURACY SYSTEM
  // =====================================================

  /// SIMPLE SHAPES FOR KIDS LEARNING
  void _generateTargetShape(int number) {
    final size = MediaQuery.of(context).size;

    double cx = size.width * 0.5;
    double top = size.height * 0.23;
    double height = size.height * 0.45;

    targetShape = [];

    switch (number) {
      case 1:
        targetShape = List.generate(
          90,
          (i) => Offset(cx, top + (height / 90) * i),
        );
        break;

      case 2:
        targetShape = [
          for (double t = 0; t < 1; t += 0.02)
            Offset(cx + 100 * (1 - t), top + 180 * (t * t)),
          for (double t = 0; t < 1; t += 0.02)
            Offset(cx - 120 + 240 * t, top + 200 + 200 * t),
        ];
        break;

      default:
        targetShape = List.generate(
          80,
          (i) => Offset(cx, top + (height / 80) * i),
        );
    }
  }

  /// Compares child's stroke to target shape
  double _calculateAccuracy() {
    if (points.isEmpty) return 0;

    int matched = 0;
    const tolerance = 35.0; // EASY FOR KIDS

    final userPoints = points.where((e) => e != null).cast<Offset>().toList();

    for (final tp in targetShape) {
      for (final up in userPoints) {
        if ((tp - up).distance <= tolerance) {
          matched++;
          break;
        }
      }
    }

    double percent = (matched / targetShape.length) * 100;
    return percent.clamp(0, 100);
  }

  // =====================================================

  @override
  Widget build(BuildContext context) {
    final numberText = widget.number.toString();

    return Scaffold(
      backgroundColor: const Color(0xFFffb938),
      body: SafeArea(
        child: Stack(
          children: [
            /// BACK BUTTON
            Positioned(
              top: 12,
              left: 12,
              child: GestureDetector(
                onTapDown: (_) => setState(() => buttonScale = .9),
                onTapUp: (_) {
                  setState(() => buttonScale = 1);
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                child: AnimatedScale(
                  scale: buttonScale,
                  duration: const Duration(milliseconds: 150),
                  child: Image.asset(
                    'assets/images/back_button.png',
                    width: 70,
                    height: 70,
                  ),
                ),
              ),
            ),

            /// MAIN AREA
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// GLOW NUMBER
                  AnimatedBuilder(
                    animation: _glowController,
                    builder: (_, __) {
                      return Text(
                        numberText,
                        style: GoogleFonts.baloo2(
                          fontSize: 380,
                          fontWeight: FontWeight.bold,
                          color: isCompleted
                              ? Colors.white.withOpacity(_glowController.value)
                              : Colors.white.withOpacity(.3),
                          shadows: isCompleted
                              ? [
                                  Shadow(
                                    color: Colors.yellowAccent.withOpacity(
                                      _glowController.value,
                                    ),
                                    blurRadius: 60,
                                  ),
                                  const Shadow(
                                    color: Colors.orangeAccent,
                                    blurRadius: 90,
                                  ),
                                ]
                              : [],
                        ),
                      );
                    },
                  ),

                  /// DRAWING CANVAS
                  GestureDetector(
                    onPanUpdate: (details) {
                      RenderBox box = context.findRenderObject() as RenderBox;

                      Offset p = box.globalToLocal(details.globalPosition);

                      p = Offset(
                        p.dx.clamp(0.0, box.size.width),
                        p.dy.clamp(0.0, box.size.height),
                      );

                      setState(() {
                        points.add(p);
                      });

                      if (points.length > 250 && !isCompleted) {
                        _markCompleted();
                      }
                    },
                    onPanEnd: (_) => points.add(null),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CustomPaint(
                        painter: TracingPainter(points),
                        size: Size.infinite,
                      ),
                    ),
                  ),

                  /// CONFETTI
                  IgnorePointer(
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      emissionFrequency: 0.06,
                      numberOfParticles: 35,
                      maxBlastForce: 10,
                      minBlastForce: 5,
                      gravity: 0.45,
                    ),
                  ),

                  /// ACCURACY BADGE
                  if (isCompleted)
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          "Accuracy: ${accuracy.toStringAsFixed(1)}%",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// NAV BUTTONS
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  // ------------------- Bottom Buttons -------------------
  Widget _buildBottomButtons(BuildContext context) {
    return Positioned(
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
                  builder: (_) =>
                      NumberTracingScreen(number: widget.number - 1),
                ),
              );
            }
          }),
          _circleButton(Icons.refresh, () => _reset()),
          _circleButton(Icons.arrow_forward, () {
            if (widget.number < 9) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      NumberTracingScreen(number: widget.number + 1),
                ),
              );
            }
          }),
        ],
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

/// ---------------- PAINTER -------------------
class TracingPainter extends CustomPainter {
  final List<Offset?> points;
  TracingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.shade400
      ..strokeWidth = 22
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
