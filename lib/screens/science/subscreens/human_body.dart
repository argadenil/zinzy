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
    BodyPart.all: BodyPartData(
      label: "All",
      description: "Learn all body parts",
      from: [],
      to: [],
      color: Color(0xFF6A5AE0),
    ),

    BodyPart.head: BodyPartData(
      label: "Head",
      description: "Top part of our body.",
      from: [Offset(0.50, 0.12)],
      to: [Offset(0.80, 0.12)],
      color: Color(0xFF90CAF9),
    ),

    BodyPart.hair: BodyPartData(
      label: "Hair",
      description: "Hair grows on head.",
      from: [Offset(0.50, 0.08)],
      to: [Offset(0.80, 0.05)],
      color: Color(0xFFCE93D8),
    ),

    BodyPart.brain: BodyPartData(
      label: "Brain",
      description: "Helps us think.",
      from: [Offset(0.50, 0.14)],
      to: [Offset(0.20, 0.08)],
      color: Color(0xFFFF8A65),
    ),

    BodyPart.eyes: BodyPartData(
      label: "Eyes",
      description: "Help us see.",
      from: [Offset(0.46, 0.22), Offset(0.54, 0.22)],
      to: [Offset(0.20, 0.22), Offset(0.80, 0.22)],
      isPair: true,
      color: Color(0xFF4FC3F7),
    ),

    BodyPart.neck: BodyPartData(
      label: "Neck",
      description: "Connects head to body.",
      from: [Offset(0.50, 0.28)],
      to: [Offset(0.80, 0.30)],
      color: Color(0xFFA1887F),
    ),

    BodyPart.chest: BodyPartData(
      label: "Chest",
      description: "Protects heart & lungs.",
      from: [Offset(0.50, 0.36)],
      to: [Offset(0.80, 0.36)],
      color: Color(0xFF81C784),
    ),

    BodyPart.heart: BodyPartData(
      label: "Heart",
      description: "Pumps blood.",
      from: [Offset(0.48, 0.40)],
      to: [Offset(0.20, 0.42)],
      color: Color(0xFFE57373),
    ),

    BodyPart.lungs: BodyPartData(
      label: "Lungs",
      description: "Help us breathe.",
      from: [Offset(0.52, 0.38)],
      to: [Offset(0.80, 0.34)],
      color: Color(0xFF81D4FA),
    ),

    BodyPart.liver: BodyPartData(
      label: "Liver",
      description: "Cleans our blood.",
      from: [Offset(0.48, 0.46)],
      to: [Offset(0.20, 0.48)],
      color: Color(0xFFBCAAA4),
    ),

    BodyPart.stomach: BodyPartData(
      label: "Stomach",
      description: "Digests food.",
      from: [Offset(0.52, 0.50)],
      to: [Offset(0.80, 0.52)],
      color: Color(0xFFFFB74D),
    ),

    BodyPart.intestines: BodyPartData(
      label: "Intestines",
      description: "Absorb nutrients.",
      from: [Offset(0.50, 0.56)],
      to: [Offset(0.80, 0.58)],
      color: Color(0xFFFFCC80),
    ),

    BodyPart.hand: BodyPartData(
      label: "Hand",
      description: "Helps us hold.",
      from: [Offset(0.26, 0.52)],
      to: [Offset(0.05, 0.60)],
      color: Color(0xFF4DB6AC),
    ),

    BodyPart.legs: BodyPartData(
      label: "Legs",
      description: "Help us walk.",
      from: [Offset(0.46, 0.72), Offset(0.54, 0.72)],
      to: [Offset(0.30, 0.90), Offset(0.70, 0.90)],
      isPair: true,
      color: Color(0xFF81C784),
    ),

    BodyPart.foot: BodyPartData(
      label: "Foot",
      description: "Supports body.",
      from: [Offset(0.46, 0.90), Offset(0.54, 0.90)],
      to: [Offset(0.30, 0.98), Offset(0.70, 0.98)],
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
            const SizedBox(height: 12),

            /// IMAGE + ARROWS (SAME COORDINATE SPACE)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: LayoutBuilder(
                  builder: (_, c) {
                    final w = c.maxWidth;
                    final h = c.maxHeight;

                    return Stack(
                      children: [_bodyImage(), ..._buildArrowLayers(w, h)],
                    );
                  },
                ),
              ),
            ),

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
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 30),
        onPressed: () => Navigator.pop(context),
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
      child: Image.asset("assets/science/body.webp", fit: BoxFit.contain),
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
                from: Offset(data.from[i].dx * w, data.from[i].dy * h),
                to: Offset(data.to[i].dx * w, data.to[i].dy * h),
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
    ),
  );

  Widget _label(String text) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 80),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    ),
  );

  /// --------------------------------------------------
  Widget _tabsGrid() {
    final items = parts.entries.toList();

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.5,
      ),
      itemBuilder: (_, i) {
        final part = items[i].key;
        final data = items[i].value;
        final active = selectedPart == part;

        return GestureDetector(
          onTap: () => setState(() => selectedPart = part),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: active
                    ? [data.color, data.color.withOpacity(0.7)]
                    : [Colors.white, Colors.white],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: data.color, width: active ? 3 : 2),
            ),
            alignment: Alignment.center,
            child: Text(
              data.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 12,
                color: active ? Colors.white : data.color,
              ),
            ),
          ),
        );
      },
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              data.label,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(data.description, textAlign: TextAlign.center),
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
      old.from != from || old.to != to || old.color != color;
}
