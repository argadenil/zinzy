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
  neck,
  chest,
  heart,
  lungs,
  liver,
  stomach,
  intestines,
  kidneys,
  shoulder,
  elbow,
  hand,
  legs,
  knee,
  foot,
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
  final Color color;

  const BodyPartData({
    required this.label,
    required this.description,
    required this.from,
    required this.to,
    required this.color,
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
  BodyPartData? _activeInfo;

  Offset p(double x, double y) => Offset(x / 100, y / 100);

  Map<BodyPart, BodyPartData> get parts => {
    BodyPart.all: BodyPartData(
      label: "All",
      description: "Learn all body parts",
      from: [],
      to: [],
      color: const Color(0xFF2979FF),
    ),
    BodyPart.head: BodyPartData(
      label: "Head",
      description: "Top part of our body.",
      from: [p(60, 15)],
      to: [p(80, 15)],
      color: const Color(0xFFFF6D00),
    ),
    BodyPart.hair: BodyPartData(
      label: "Hair",
      description: "Hair grows on head.",
      from: [p(60, 10)],
      to: [p(80, 10)],
      color: const Color(0xFFAA00FF),
    ),
    BodyPart.brain: BodyPartData(
      label: "Brain",
      description: "Helps us think.",
      from: [p(50, 14)],
      to: [p(20, 8)],
      color: const Color(0xFFFF4081),
    ),
    BodyPart.eyes: BodyPartData(
      label: "Eyes",
      description: "Help us see.",
      from: [p(40, 25)],
      to: [p(20, 25)],
      color: const Color(0xFF00BFA5),
    ),
    BodyPart.neck: BodyPartData(
      label: "Neck",
      description: "Connects head to body.",
      from: [p(50, 40)],
      to: [p(80, 30)],
      color: const Color(0xFF3D5AFE),
    ),
    BodyPart.chest: BodyPartData(
      label: "Chest",
      description: "Protects heart & lungs.",
      from: [p(55, 50)],
      to: [p(80, 50)],
      color: const Color(0xFF42A5F5),
    ),
    BodyPart.heart: BodyPartData(
      label: "Heart",
      description: "Pumps blood.",
      from: [p(48, 50)],
      to: [p(20, 42)],
      color: const Color(0xFFFF1744),
    ),
    BodyPart.lungs: BodyPartData(
      label: "Lungs",
      description: "Help us breathe.",
      from: [p(55, 50)],
      to: [p(80, 50)],
      color: const Color(0xFF00E5FF),
    ),
    BodyPart.liver: BodyPartData(
      label: "Liver",
      description: "Cleans our blood.",
      from: [p(48, 56)],
      to: [p(20, 56)],
      color: const Color(0xFF7C4DFF),
    ),
    BodyPart.stomach: BodyPartData(
      label: "Stomach",
      description: "Digests food.",
      from: [p(52, 60)],
      to: [p(80, 60)],
      color: const Color(0xFFFF9100),
    ),
    BodyPart.intestines: BodyPartData(
      label: "Intestines",
      description: "Absorb nutrients.",
      from: [p(50, 65)],
      to: [p(80, 75)],
      color: const Color(0xFFD500F9),
    ),
    BodyPart.hand: BodyPartData(
      label: "Hand",
      description: "Helps us hold.",
      from: [p(26, 65)],
      to: [p(5, 75)],
      color: const Color(0xFF00C853),
    ),
    BodyPart.legs: BodyPartData(
      label: "Legs",
      description: "Help us walk.",
      from: [p(45, 85)],
      to: [p(30, 85)],
      color: const Color(0xFF2962FF),
    ),
    BodyPart.foot: BodyPartData(
      label: "Foot",
      description: "Supports body.",
      from: [p(40, 95)],
      to: [p(20, 90)],
      color: const Color(0xFF00B0FF),
    ),
  };

  /// --------------------------------------------------
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
                  const SizedBox(width: 12),
                  if (_activeInfo != null)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.shade100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _activeInfo!.label,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _activeInfo!.description,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 10),

              /// IMAGE + ARROWS
              Expanded(
                child: LayoutBuilder(
                  builder: (_, c) {
                    final w = c.maxWidth;
                    final h = c.maxHeight;

                    return Stack(
                      children: [_bodyImage(), ..._buildArrows(w, h)],
                    );
                  },
                ),
              ),

              /// TABS
              Expanded(child: _tabsGrid()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bodyImage() => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xff3c2815), width: 5),
    ),
    child: Center(
      child: Image.asset("assets/science/body.webp", fit: BoxFit.contain),
    ),
  );

  List<Widget> _buildArrows(double w, double h) {
    final entries = selectedPart == BodyPart.all
        ? parts.entries.where((e) => e.key != BodyPart.all)
        : parts.entries.where((e) => e.key == selectedPart);

    return entries.map((e) {
      final d = e.value;

      return Stack(
        children: [
          for (int i = 0; i < d.from.length; i++)
            CustomPaint(
              size: Size(w, h),
              painter: ArrowPainter(
                from: Offset(d.from[i].dx * w, d.from[i].dy * h),
                to: Offset(d.to[i].dx * w, d.to[i].dy * h),
                color: Colors.red,
              ),
            ),
          Positioned(
            left: (d.to.first.dx * w) - 14,
            top: (d.to.first.dy * h) - 14,
            child: GestureDetector(
              onTap: () => setState(() => _activeInfo = d),
              child: _label(d.label),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _label(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.black87,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 13),
    ),
  );

  Widget _tabsGrid() {
    final items = parts.entries.toList();

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.7,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
      ),
      itemBuilder: (_, i) {
        final part = items[i].key;
        final data = items[i].value;
        final active = selectedPart == part;

        return GestureDetector(
          onTap: () => setState(() {
            selectedPart = part;
            _activeInfo = data;
          }),
          child: Container(
            decoration: BoxDecoration(
              color: active ? data.color : Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.black, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              data.label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
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

  ArrowPainter({required this.from, required this.to, required this.color});

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
      old.from != from || old.to != to;
}
