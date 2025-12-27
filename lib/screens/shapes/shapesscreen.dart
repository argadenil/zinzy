import 'package:flutter/material.dart';

class ShapesScreen extends StatefulWidget {
  const ShapesScreen({super.key});

  @override
  State<ShapesScreen> createState() => _ShapesScreenState();
}

class _ShapesScreenState extends State<ShapesScreen> {
  final List<Map<String, dynamic>> shapes = [
    {"name": "Circle", "icon": Icons.circle, "color": Colors.red, "info": "A circle is round. It has no corners."},
    {"name": "Square", "icon": Icons.crop_square, "color": Colors.blue, "info": "A square has 4 equal sides."},
    {"name": "Rectangle", "icon": Icons.rectangle_outlined, "color": Colors.orange, "info": "A rectangle has 4 sides. Opposite sides are equal."},
    {"name": "Triangle", "icon": Icons.change_history, "color": Colors.green, "info": "A triangle has 3 sides."},
    {"name": "Oval", "icon": Icons.egg, "color": Colors.teal, "info": "An oval looks like a stretched circle."},
    {"name": "Diamond", "icon": Icons.diamond, "color": Colors.brown, "info": "A diamond has 4 equal slanted sides."},
    {"name": "Pentagon", "icon": Icons.pentagon, "color": Colors.indigo, "info": "A pentagon has 5 sides."},
    {"name": "Hexagon", "icon": Icons.hexagon, "color": Colors.deepOrange, "info": "A hexagon has 6 sides."},
    {"name": "Octagon", "icon": Icons.stop, "color": Colors.cyan, "info": "An octagon has 8 sides."},
    {"name": "Parallelogram", "icon": Icons.crop_rotate, "color": Colors.lime, "info": "Opposite sides are equal and parallel."},
    {"name": "Trapezium", "icon": Icons.filter_none, "color": Colors.amber, "info": "One pair of sides are parallel."},
    {"name": "Star", "icon": Icons.star, "color": Colors.purple, "info": "A star has pointed corners."},
    {"name": "Heart", "icon": Icons.favorite, "color": Colors.pink, "info": "A heart shows love and care."},
    {"name": "Cube", "icon": Icons.view_in_ar, "color": Colors.blueGrey, "info": "A cube has 6 square faces."},
    {"name": "Sphere", "icon": Icons.sports_baseball, "color": Colors.lightBlue, "info": "A sphere is round like a ball."},
    {"name": "Cylinder", "icon": Icons.wine_bar, "color": Colors.greenAccent, "info": "A cylinder has two circles and a curved surface."},
    {"name": "Cone", "icon": Icons.icecream, "color": Colors.orangeAccent, "info": "A cone has a circular base and a point."},
    {"name": "Pyramid", "icon": Icons.account_balance, "color": Colors.redAccent, "info": "A pyramid has triangular sides and a base."},
  ];

  int tappedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4FA),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          "📐 Shapes",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: shapes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final shape = shapes[index];
          final isTapped = tappedIndex == index;

          return GestureDetector(
            onTapDown: (_) => setState(() => tappedIndex = index),
            onTapCancel: () => setState(() => tappedIndex = -1),
            onTapUp: (_) {
              setState(() => tappedIndex = -1);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShapeDetailScreen(shape: shape),
                ),
              );
            },
            child: AnimatedScale(
              scale: isTapped ? 0.94 : 1,
              duration: const Duration(milliseconds: 120),
              child: _ShapeCard(shape: shape),
            ),
          );
        },
      ),
    );
  }
}

/// ================================
/// CLEAN MODERN SHAPE CARD
/// ================================
class _ShapeCard extends StatelessWidget {
  final Map<String, dynamic> shape;

  const _ShapeCard({required this.shape});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            shape["color"].withOpacity(0.85),
            shape["color"].withOpacity(0.65),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: shape["color"].withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.25),
            ),
            child: Icon(
              shape["icon"],
              size: 42,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              shape["name"],
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================================
/// SHAPE DETAIL SCREEN (UNCHANGED)
/// ================================
class ShapeDetailScreen extends StatelessWidget {
  final Map<String, dynamic> shape;

  const ShapeDetailScreen({super.key, required this.shape});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: shape["color"].withOpacity(0.12),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    "assets/images/back_button.webp",
                    height: 48,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              height: 260,
              width: 260,
              decoration: BoxDecoration(
                color: shape["color"],
                borderRadius: BorderRadius.circular(44),
                boxShadow: [
                  BoxShadow(
                    color: shape["color"].withOpacity(0.6),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(shape["icon"], size: 160, color: Colors.white),
            ),
            const SizedBox(height: 30),
            Text(
              shape["name"],
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Text(
                shape["info"],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
