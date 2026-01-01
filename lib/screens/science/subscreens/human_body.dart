import 'package:flutter/material.dart';

/// --------------------------------------------------
/// ENUM
/// --------------------------------------------------
enum BodyPart {
  all,
  head,
  hair,
  brain,
  eyes,
  ear,
  nose,
  mouth,
  heart,
  lungs,
  stomach,
  kidneys,
  hand,
  legs,
  knee,
  toe,
}

/// --------------------------------------------------
/// DATA MODEL
/// --------------------------------------------------
class BodyPartData {
  final String label;
  final String description;
  final List<Offset> from;
  final List<Offset> to;
  final bool isPair;
  final Color color;

  const BodyPartData({
    required this.label,
    required this.description,
    required this.from,
    required this.to,
    required this.color,
    this.isPair = false,
  });
}

/// --------------------------------------------------
/// MAIN SCREEN
/// --------------------------------------------------
class HumanBodyScreen extends StatefulWidget {
  const HumanBodyScreen({super.key});

  @override
  State<HumanBodyScreen> createState() => _HumanBodyScreenState();
}

class _HumanBodyScreenState extends State<HumanBodyScreen> {
  BodyPart selectedPart = BodyPart.all;

  /// --------------------------------------------------
  /// BODY PART DATA
  /// --------------------------------------------------
  final Map<BodyPart, BodyPartData> parts = {
    BodyPart.all: const BodyPartData(
      label: "All",
      description: "Learn all body parts",
      from: [],
      to: [],
      color: Color(0xFF6A5AE0),
    ),

    BodyPart.head: const BodyPartData(
      label: "Head",
      description: "The top part of our body.",
      from: [Offset(0.50, 0.16)],
      to: [Offset(0.72, 0.12)],
      color: Color(0xFF90CAF9),
    ),

    BodyPart.hair: const BodyPartData(
      label: "Hair",
      description: "Hair grows on our head.",
      from: [Offset(0.50, 0.08)],
      to: [Offset(0.72, 0.04)],
      color: Color(0xFFCE93D8),
    ),

    BodyPart.brain: const BodyPartData(
      label: "Brain",
      description: "Helps us think and learn.",
      from: [Offset(0.50, 0.14)],
      to: [Offset(0.72, 0.02)],
      color: Color(0xFFFF8A65),
    ),

    BodyPart.eyes: const BodyPartData(
      label: "Eyes",
      description: "Help us see.",
      from: [
        Offset(0.46, 0.20),
        Offset(0.54, 0.20),
      ],
      to: [
        Offset(0.28, 0.18),
        Offset(0.72, 0.18),
      ],
      isPair: true,
      color: Color(0xFF4FC3F7),
    ),

    BodyPart.ear: const BodyPartData(
      label: "Ears",
      description: "Help us hear.",
      from: [
        Offset(0.42, 0.22),
        Offset(0.58, 0.22),
      ],
      to: [
        Offset(0.18, 0.20),
        Offset(0.82, 0.20),
      ],
      isPair: true,
      color: Color(0xFFFFD54F),
    ),

    BodyPart.nose: const BodyPartData(
      label: "Nose",
      description: "Helps us smell.",
      from: [Offset(0.50, 0.25)],
      to: [Offset(0.72, 0.25)],
      color: Color(0xFFFFCC80),
    ),

    BodyPart.mouth: const BodyPartData(
      label: "Mouth",
      description: "Helps us eat and talk.",
      from: [Offset(0.50, 0.29)],
      to: [Offset(0.72, 0.29)],
      color: Color(0xFFF48FB1),
    ),

    BodyPart.heart: const BodyPartData(
      label: "Heart",
      description: "Pumps blood in our body.",
      from: [Offset(0.50, 0.46)],
      to: [Offset(0.72, 0.42)],
      color: Color(0xFFE57373),
    ),

    BodyPart.lungs: const BodyPartData(
      label: "Lungs",
      description: "Help us breathe.",
      from: [Offset(0.50, 0.38)],
      to: [Offset(0.72, 0.32)],
      color: Color(0xFF81C784),
    ),

    BodyPart.stomach: const BodyPartData(
      label: "Stomach",
      description: "Helps digest food.",
      from: [Offset(0.50, 0.60)],
      to: [Offset(0.72, 0.60)],
      color: Color(0xFFFFB74D),
    ),

    BodyPart.kidneys: const BodyPartData(
      label: "Kidneys",
      description: "Clean our blood.",
      from: [
        Offset(0.46, 0.62),
        Offset(0.54, 0.62),
      ],
      to: [
        Offset(0.26, 0.68),
        Offset(0.74, 0.68),
      ],
      isPair: true,
      color: Color(0xFFBA68C8),
    ),

    BodyPart.hand: const BodyPartData(
      label: "Hand",
      description: "Helps us hold things.",
      from: [Offset(0.28, 0.58)],
      to: [Offset(0.06, 0.66)],
      color: Color(0xFF4DB6AC),
    ),

    BodyPart.legs: const BodyPartData(
      label: "Legs",
      description: "Help us walk and run.",
      from: [
        Offset(0.46, 0.74),
        Offset(0.54, 0.74),
      ],
      to: [
        Offset(0.28, 0.88),
        Offset(0.72, 0.88),
      ],
      isPair: true,
      color: Color(0xFF81C784),
    ),

    BodyPart.knee: const BodyPartData(
      label: "Knees",
      description: "Help our legs bend.",
      from: [
        Offset(0.46, 0.68),
        Offset(0.54, 0.68),
      ],
      to: [
        Offset(0.28, 0.76),
        Offset(0.72, 0.76),
      ],
      isPair: true,
      color: Color(0xFFAED581),
    ),

    BodyPart.toe: const BodyPartData(
      label: "Toes",
      description: "Help us balance.",
      from: [
        Offset(0.46, 0.90),
        Offset(0.54, 0.90),
      ],
      to: [
        Offset(0.28, 0.98),
        Offset(0.72, 0.98),
      ],
      isPair: true,
      color: Color(0xFFFFAB91),
    ),
  };

  /// --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFBB2D),
      body: SafeArea(
        child: Column(
          children: [
            _backButton(),
            const Text(
              "Human Body",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),

            /// BODY IMAGE + ARROWS
            SizedBox(
              width: 360,
              height: 420,
              child: LayoutBuilder(
                builder: (_, c) {
                  final w = c.maxWidth;
                  final h = c.maxHeight;
                  return Stack(
                    children: [
                      _bodyImage(),
                      ..._buildArrowLayers(w, h),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 8),
            Expanded(child: _tabsGrid()),
          ],
        ),
      ),
    );
  }

  /// --------------------------------------------------
  Widget _backButton() => Padding(
        padding: const EdgeInsets.all(14),
        child: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios,
                size: 34, color: Color(0xff3c2815)),
          ),
        ),
      );

  Widget _bodyImage() => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xff3c2815), width: 5),
        ),
        child: Center(
          child: Image.asset(
            "assets/science/body.webp",
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.person, size: 200),
          ),
        ),
      );

  /// --------------------------------------------------
  List<Widget> _buildArrowLayers(double w, double h) {
    final entries = selectedPart == BodyPart.all
        ? parts.entries.where((e) => e.key != BodyPart.all)
        : parts.entries.where((e) => e.key == selectedPart);

    return entries.map((e) {
      final data = e.value;

      return Stack(
        children: [
          for (int i = 0; i < data.from.length; i++)
            CustomPaint(
              size: Size(w, h),
              painter: ArrowPainter(
                from: Offset(
                    data.from[i].dx * w, data.from[i].dy * h),
                to:
                    Offset(data.to[i].dx * w, data.to[i].dy * h),
                color: data.color,
              ),
            ),

          Positioned(
            left: (data.to.first.dx * w) - 14,
            top: (data.to.first.dy * h) - 14,
            child: GestureDetector(
              onTap: () => _showInfo(data),
              child: Column(
                children: [
                  _dot(data.color),
                  const SizedBox(height: 4),
                  _label(data.label),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _dot(Color color) => Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(blurRadius: 4, offset: Offset(0, 2))
          ],
        ),
      );

  Widget _label(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
      );

  /// --------------------------------------------------
  Widget _tabsGrid() {
    final items = parts.entries.toList();
    const borderColor = Color(0xff3c2815);

    return Center(
      child: SizedBox(
        width: 360,
        child: GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.6,
          ),
          itemBuilder: (_, i) {
            final part = items[i].key;
            final data = items[i].value;
            final active = selectedPart == part;

            return GestureDetector(
              onTap: () => setState(() => selectedPart = part),
              child: AnimatedScale(
                scale: active ? 1.1 : 1,
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutBack,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: active
                        ? data.color
                        : Colors.white.withOpacity(0.85),
                    borderRadius:
                        BorderRadius.circular(active ? 28 : 22),
                    border: Border.all(
                        color: borderColor,
                        width: active ? 3 : 2),
                    boxShadow: active
                        ? const [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 3))
                          ]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    data.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color:
                          active ? Colors.white : borderColor,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// --------------------------------------------------
  void _showInfo(BodyPartData data) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              data.label,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            Text(
              data.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}

/// --------------------------------------------------
/// ARROW PAINTER
/// --------------------------------------------------
class ArrowPainter extends CustomPainter {
  final Offset from;
  final Offset to;
  final Color color;

  ArrowPainter({
    required this.from,
    required this.to,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(from, to, paint);
  }

  @override
  bool shouldRepaint(covariant ArrowPainter old) =>
      old.from != from || old.to != to || old.color != color;
}
