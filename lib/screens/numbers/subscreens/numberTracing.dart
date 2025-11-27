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

  @override
  void initState() {
    super.initState();

    /// Confetti Controller
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
    });
    _glowController.repeat();
  }

  void _markCompleted() {
    setState(() => isCompleted = true);
    _confettiController.play();
    _glowController.stop();
  }

  @override
  Widget build(BuildContext context) {
    final numberText = widget.number.toString();

    return Scaffold(
      backgroundColor: const Color(0xFFffb938),
      body: SafeArea(
        child: Stack(
          children: [
            /// -------------- BACK BUTTON ----------------
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

            /// ------------------- MAIN TRACING AREA ----------------
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// ---- Number Glow ----
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
                                    blurRadius: 50,
                                  ),
                                  const Shadow(
                                    color: Colors.orangeAccent,
                                    blurRadius: 80,
                                  ),
                                ]
                              : [],
                        ),
                      );
                    },
                  ),

                  /// ---- Drawing Canvas ----
                  GestureDetector(
                    onPanUpdate: (details) {
                      RenderBox box = context.findRenderObject() as RenderBox;

                      Offset p = box.globalToLocal(details.globalPosition);

                      // clamp to screen (avoid out-of-bound pixel errors)
                      p = Offset(
                        p.dx.clamp(0.0, box.size.width),
                        p.dy.clamp(0.0, box.size.height),
                      );

                      setState(() {
                        points.add(p);
                      });

                      if (points.length > 260 && !isCompleted) {
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

                  /// ---- CONFETTI ----
                  IgnorePointer(
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      emissionFrequency: 0.06,
                      numberOfParticles: 35,
                      maxBlastForce: 9,
                      minBlastForce: 4,
                      gravity: 0.45,
                    ),
                  ),
                ],
              ),
            ),

            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  /// ----------------- Navigation Buttons -----------------
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

/// ------------------------ Painter ------------------------
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
