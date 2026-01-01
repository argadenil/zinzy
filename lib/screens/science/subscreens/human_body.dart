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

  /// --------------------------------------------------
  /// BODY PART DATA
  /// --------------------------------------------------
  Offset p(double xPercent, double yPercent) {
    return Offset(xPercent / 100, yPercent / 100);
  }

  Map<BodyPart, BodyPartData> get parts => {
    BodyPart.all: BodyPartData(
      label: "All",
      description: "Learn all body parts",
      from: [],
      to: [],
      // A bright Royal Blue (High contrast vs yellow)
      color: const Color(0xFF2979FF),
    ),

    BodyPart.head: BodyPartData(
      label: "Head",
      description: "Top part of our body.",
      from: [p(60, 15)],
      to: [p(80, 15)],
      // Vibrant Orange (Darker than background to stand out)
      color: const Color(0xFFFF6D00),
    ),

    BodyPart.hair: BodyPartData(
      label: "Hair",
      description: "Hair grows on head.",
      from: [p(60, 10)],
      to: [p(80, 10)],
      // Deep Purple (Fun, high contrast)
      color: const Color(0xFFAA00FF),
    ),

    BodyPart.brain: BodyPartData(
      label: "Brain",
      description: "Helps us think.",
      from: [p(50, 14)],
      to: [p(20, 8)],
      // Hot Pink (Playful, distinct from Heart red)
      color: const Color(0xFFFF4081),
    ),

    BodyPart.eyes: BodyPartData(
      label: "Eyes",
      description: "Help us see.",
      from: [p(40, 25)],
      to: [p(20, 25)],
      // Teal/Cyan (Very clear against yellow)
      color: const Color(0xFF00BFA5),
    ),

    BodyPart.neck: BodyPartData(
      label: "Neck",
      description: "Connects head to body.",
      from: [p(50, 40)],
      to: [p(80, 30)],
      // Indigo (Solid, stabilizing color)
      color: const Color(0xFF3D5AFE),
    ),

    BodyPart.chest: BodyPartData(
      label: "Chest",
      description: "Protects heart & lungs.",
      from: [p(55, 50)],
      to: [p(80, 50)],
      // Soft Blue
      color: const Color(0xFF42A5F5),
    ),

    BodyPart.heart: BodyPartData(
      label: "Heart",
      description: "Pumps blood.",
      from: [p(48, 50)],
      to: [p(20, 42)],
      // Bright Cherry Red (Classic Heart color)
      color: const Color(0xFFFF1744),
    ),

    BodyPart.lungs: BodyPartData(
      label: "Lungs",
      description: "Help us breathe.",
      from: [p(55, 50)],
      to: [p(80, 50)],
      // Sky Blue (Airy feeling)
      color: const Color(0xFF00E5FF),
    ),

    BodyPart.liver: BodyPartData(
      label: "Liver",
      description: "Cleans our blood.",
      from: [p(48, 56)],
      to: [p(20, 56)],
      // Deep Violet
      color: const Color(0xFF7C4DFF),
    ),

    BodyPart.stomach: BodyPartData(
      label: "Stomach",
      description: "Digests food.",
      from: [p(52, 60)],
      to: [p(80, 60)],
      // Coral/Salmon (Warm but distinct from red)
      color: const Color(0xFFFF9100),
    ),

    BodyPart.intestines: BodyPartData(
      label: "Intestines",
      description: "Absorb nutrients.",
      from: [p(50, 65)],
      to: [p(80, 75)],
      // Magenta
      color: const Color(0xFFD500F9),
    ),

    BodyPart.hand: BodyPartData(
      label: "Hand",
      description: "Helps us hold.",
      from: [p(26, 65)],
      to: [p(5, 75)],
      // Mint/Kelly Green (Avoids olive/muddy greens)
      color: const Color(0xFF00C853),
    ),

    BodyPart.legs: BodyPartData(
      label: "Legs",
      description: "Help us walk.",
      from: [p(45, 85)],
      to: [p(30, 85)],
      // Azure Blue
      color: const Color(0xFF2962FF),
    ),

    BodyPart.foot: BodyPartData(
      label: "Foot",
      description: "Supports body.",
      from: [p(40, 95)],
      to: [p(20, 90)],
      // Emerald Green
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  'assets/images/back_button.webp',
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
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
                color: Color(0xFFd26868),
              ),
            ),

          Positioned(
            left: (data.to.first.dx * w) - 14,
            top: (data.to.first.dy * h) - 14,
            child: GestureDetector(
              onTap: () => _showInfo(data),
              child: Column(
                children: [const SizedBox(height: 4), _label(data.label)],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _label(String text) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 96),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2B2B), // softer than pure black
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600, // better readability for kids
            height: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _tabsGrid() {
    final items = parts.entries.toList();

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 2.7,
      ),
      itemBuilder: (_, i) {
        final part = items[i].key;
        final data = items[i].value;
        final active = selectedPart == part;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 1, end: active ? 1.05 : 1),
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          builder: (_, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: GestureDetector(
            onTap: () => setState(() => selectedPart = part),
            child: Container(
              decoration: BoxDecoration(
                color: active ? data.color : Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: active ? Colors.black : Colors.black54,
                  width: active ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: active
                        ? data.color.withOpacity(0.45)
                        : Colors.black.withOpacity(0.12),
                    blurRadius: active ? 14 : 6,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                data.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: active ? 16 : 14,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                  letterSpacing: 0.3,
                ),
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
