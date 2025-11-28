import 'dart:math';
import 'package:flutter/material.dart';

class NumberColoringScreen extends StatefulWidget {
  const NumberColoringScreen({super.key});

  @override
  State<NumberColoringScreen> createState() => _NumberColoringScreenState();
}

class _NumberColoringScreenState extends State<NumberColoringScreen>
    with TickerProviderStateMixin {
  int currentNumber = 1;
  Color selectedColor = Colors.red;
  final Random _random = Random();

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.yellow,
    Colors.teal,
    Colors.cyan,
  ];

  final List<Offset> _splashes = [];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void nextNumber() {
    setState(() {
      currentNumber = _random.nextInt(10) + 1;
      _splashes.clear();
    });
  }

  void addSplash(Offset localPos) {
    setState(() {
      _splashes.add(localPos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: const Text("✨ Magic Number Coloring"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Animated Number Area
          ScaleTransition(
            scale: _pulseAnimation,
            child: GestureDetector(
              onPanDown: (d) => addSplash(d.localPosition),
              onPanUpdate: (d) => addSplash(d.localPosition),
              child: Container(
                height: 280,
                width: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(color: Colors.deepPurple, width: 6),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: CustomPaint(
                  painter: _NumberPainter(
                    number: currentNumber,
                    color: selectedColor,
                    splashes: _splashes,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            "Tap or Drag to Color ✨",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),

          const SizedBox(height: 16),

          // Color Palette
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: colors.length,
              itemBuilder: (context, index) {
                final color = colors[index];
                return GestureDetector(
                  onTap: () => setState(() => selectedColor = color),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedColor == color
                            ? Colors.black
                            : Colors.transparent,
                        width: 4,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Spacer(),

          // Controls
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: nextNumber,
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                  label: const Text(
                    "Next",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    setState(() => _splashes.clear());
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text(
                    "Reset",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberPainter extends CustomPainter {
  final int number;
  final Color color;
  final List<Offset> splashes;

  _NumberPainter({
    required this.number,
    required this.color,
    required this.splashes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Number paint
    final textPainter = TextPainter(
      text: TextSpan(
        text: number.toString(),
        style: TextStyle(
          fontSize: 200,
          fontWeight: FontWeight.bold,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 6
            ..color = Colors.black54,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2.3,
    );

    // Draw outline
    textPainter.paint(canvas, offset);

    // Glow paint
    final glowPaint = Paint()
      ..color = color.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    // Draw color splashes
    for (final splash in splashes) {
      canvas.drawCircle(splash, 25, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
