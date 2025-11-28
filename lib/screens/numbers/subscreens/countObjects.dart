import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class CountObjectsScreen extends StatefulWidget {
  const CountObjectsScreen({super.key});

  @override
  State<CountObjectsScreen> createState() => _CountObjectsScreenState();
}

class _CountObjectsScreenState extends State<CountObjectsScreen>
    with TickerProviderStateMixin {

  final Random _random = Random();

  int _objectCount = 0;
  bool _showSuccess = false;
  bool _showWrong = false;
  bool _confettiPlayed = false;


  final List<String> _objectImages = [
    'assets/images/alphabets/a.png',
    'assets/images/alphabets/f.png',
    'assets/images/alphabets/g.png',
    'assets/images/alphabets/h.png',
    'assets/images/alphabets/i.png',
    'assets/images/alphabets/k.png',
    'assets/images/pencil.png',
    'assets/images/alphabets/m.png',
    'assets/images/alphabets/t.png',
    'assets/images/alphabets/v.png',
  ];

  String _currentObject = "";
  List<Offset> _positions = [];

  late final AnimationController _pulseController;
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _generateObjects();
  }

void _generateObjects() {
  setState(() {
    _showSuccess = false;
    _showWrong = false;

    _objectCount = _random.nextInt(9) + 1;
    _currentObject = _objectImages[_random.nextInt(_objectImages.length)];

    _positions.clear();

    const double minDistance = 0.18; // space between objects
    const int maxTries = 100;

    for (int i = 0; i < _objectCount; i++) {
      bool placed = false;

      for (int t = 0; t < maxTries && !placed; t++) {
        final Offset pos = Offset(
          0.1 + _random.nextDouble() * 0.8,
          0.1 + _random.nextDouble() * 0.8,
        );

        bool overlaps = false;

        for (final existing in _positions) {
          final double dx = (pos.dx - existing.dx);
          final double dy = (pos.dy - existing.dy);
          final double dist = sqrt(dx * dx + dy * dy);

          if (dist < minDistance) {
            overlaps = true;
            break;
          }
        }

        if (!overlaps) {
          _positions.add(pos);
          placed = true;
        }
      }

      // Fallback if no good position found
      if (!placed) {
        _positions.add(
          Offset(
            0.1 + _random.nextDouble() * 0.8,
            0.1 + _random.nextDouble() * 0.8,
          ),
        );
      }
    }
  });
}


void _checkAnswer(int selected) {
  if (selected == _objectCount) {
    if (_confettiPlayed) return; // prevent double fire

    setState(() {
      _showSuccess = true;
      _showWrong = false;
      _confettiPlayed = true;
    });

    // stop any running animation before playing
    _confettiController.stop();
    _confettiController.play();

    Future.delayed(const Duration(seconds: 1), () {
      _confettiPlayed = false; // reset for next round
      _generateObjects();
    });
  } else {
    setState(() {
      _showWrong = true;
      _showSuccess = false;
    });
  }
}

  @override
  void dispose() {
    _pulseController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          /// Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFE082), Color(0xFFFFC107)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// Floating blobs
          ...List.generate(8, (_) {
            return Positioned(
              top: _random.nextDouble() * size.height,
              left: _random.nextDouble() * size.width,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
            );
          }),

          /// Main UI
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),

                /// Back
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/images/back_button.png',
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// Glass container with objects
                Expanded(
                  flex: 6,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: const Color(0xff3c2815),
                              width: 5,
                            ),
                            color: Colors.white.withOpacity(0.08),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final boxWidth = constraints.maxWidth;
                              final boxHeight = constraints.maxHeight;

                              return RepaintBoundary(
                                child: Stack(
                                  children: List.generate(_objectCount, (index) {
                                    final pos = _positions[index];

                                    return Positioned(
                                      left: pos.dx * (boxWidth - 100),
                                      top: pos.dy * (boxHeight - 100),
                                      child: ScaleTransition(
                                        scale: Tween<double>(
                                          begin: 0.95,
                                          end: 1.1,
                                        ).animate(_pulseController),
                                        child: Image.asset(
                                          _currentObject,
                                          width: 95,
                                          height: 95,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                /// Feedback
                if (_showSuccess)
                  const Text(
                    "✨ Perfect!",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                if (_showWrong)
                  const Text(
                    "❌ Try again",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                const SizedBox(height: 10),

                /// Number buttons
                Expanded(
                  flex: 3,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                    itemBuilder: (context, index) {
                      final number = index + 1;
                      return GestureDetector(
                        onTap: () => _checkAnswer(number),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xffE53935), Color(0xffB71C1C)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xff3c2815),
                              width: 4,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "$number",
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          /// ✅ Optimized Confetti (no freeze)
          RepaintBoundary(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                emissionFrequency: 0.04,    // lower load
                numberOfParticles: 100,      // less particles
                gravity: 0.1,             // smoother
                maxBlastForce: 100,
                minBlastForce: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
