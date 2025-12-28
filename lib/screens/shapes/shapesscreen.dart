import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'dart:math' as math;

// --------------------------------------------------
/// DATA MODEL
/// --------------------------------------------------
class ShapeItem {
  final String name;
  final String description;
  final String simpleFact; // Short text like "Round!" or "4 Sides"
  final int sides;
  final int corners;
  final Color color;
  final bool is3D;
  final String? asset;

  ShapeItem({
    required this.name,
    required this.description,
    required this.simpleFact,
    required this.sides,
    required this.corners,
    required this.color,
    this.asset,
    this.is3D = false,
  });
}

/// --------------------------------------------------
/// SHAPES DATA (Expanded)
/// --------------------------------------------------
final List<ShapeItem> shapesList = [
  ShapeItem(
    name: 'Circle',
    description:
        'A circle is perfectly round. It looks like a yummy cookie or a wheel!',
    simpleFact: 'Round!',
    sides: 0,
    corners: 0,
    color: const Color(0xFFFF6F61), // Coral
  ),
  ShapeItem(
    name: 'Square',
    description:
        'A square has 4 equal sides. It looks like a box or a slice of toast!',
    simpleFact: 'Equal Sides',
    sides: 4,
    corners: 4,
    color: const Color(0xFF42A5F5), // Blue
  ),
  ShapeItem(
    name: 'Rectangle',
    description:
        'A rectangle is like a long square. Doors and phones are rectangles.',
    simpleFact: 'Long & Short',
    sides: 4,
    corners: 4,
    color: const Color(0xFF66BB6A), // Green
  ),
  ShapeItem(
    name: 'Triangle',
    description:
        'A triangle has 3 sharp corners. It looks like a slice of pizza!',
    simpleFact: '3 Points',
    sides: 3,
    corners: 3,
    color: const Color(0xFFAB47BC), // Purple
  ),
  ShapeItem(
    name: 'Star',
    description: 'A star twinkles in the sky at night. It has 5 points!',
    simpleFact: 'Twinkle!',
    sides: 10,
    corners: 5,
    color: const Color(0xFFFFD54F), // Gold
  ),
  ShapeItem(
    name: 'Heart',
    description:
        'A heart shape means love. It is curved and pointed at the bottom.',
    simpleFact: 'Love <3',
    sides: 2,
    corners: 1,
    color: const Color(0xFFEC407A), // Pink
  ),
  ShapeItem(
    name: 'Pentagon',
    description: 'A pentagon is a house shape with 5 sides.',
    simpleFact: '5 Sides',
    sides: 5,
    corners: 5,
    color: const Color(0xFF26C6DA), // Cyan
  ),
  // --- 3D Objects ---
  ShapeItem(
    name: 'Cube',
    description: 'A cube is a 3D box. Dice and ice cubes are this shape.',
    simpleFact: 'Solid Box',
    sides: 6,
    corners: 8,
    color: const Color(0xFF5C6BC0), // Indigo
    asset: 'assets/shapes/cube.glb',
    is3D: true,
  ),
  ShapeItem(
    name: 'Sphere',
    description: 'A sphere is a ball. You can roll it on the floor!',
    simpleFact: 'Bouncy!',
    sides: 0,
    corners: 0,
    color: const Color(0xFFFF7043), // Deep Orange
    asset: 'assets/shapes/sphere.glb',
    is3D: true,
  ),
];

/// --------------------------------------------------
/// SHAPES SCREEN (HOME)
/// --------------------------------------------------
class ShapesScreen extends StatelessWidget {
  const ShapesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // Very light orange/cream bg
      appBar: AppBar(
        title: const Text(
          'Shapes Fun! 🎈',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFF5D4037),
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: shapesList.length,
        // 2 Columns is better for small kids (bigger touch targets)
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          final shape = shapesList[index];
          return ShapeCard(shape: shape);
        },
      ),
    );
  }
}

/// --------------------------------------------------
/// SHAPE CARD WIDGET
/// --------------------------------------------------
class ShapeCard extends StatelessWidget {
  final ShapeItem shape;

  const ShapeCard({super.key, required this.shape});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ShapeDetailScreen(shape: shape)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: shape.color.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded allows the shape to take up available space
            Expanded(
              flex: 3,
              child: Center(
                child: SizedBox(
                  width: 90,
                  height: 90,
                  // If 3D, show an Icon representing 3D, else draw the shape
                  child: shape.is3D
                      ? Icon(
                          Icons.view_in_ar_outlined, // Generic 3D icon
                          size: 70,
                          color: shape.color,
                        )
                      : CustomPaint(
                          painter: ShapePainter(shape.name, shape.color),
                          size: const Size(80, 80),
                        ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    shape.name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

/// --------------------------------------------------
/// DETAIL SCREEN
/// --------------------------------------------------
class ShapeDetailScreen extends StatelessWidget {
  final ShapeItem shape;

  const ShapeDetailScreen({super.key, required this.shape});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: shape.color, // Full screen color background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // --- TOP SECTION: THE SHAPE VISUAL ---
          Expanded(
            flex: 4,
            child: Center(
              child: Hero(
                tag: shape.name,
                child: SizedBox(
                  width: 220,
                  height: 220,
                  child: shape.is3D
                      ? Flutter3DViewer(
                          src: shape.asset!,
                          enableTouch: true,
                          progressBarColor: Colors.white,
                        )
                      : CustomPaint(
                          painter: ShapePainter(
                            shape.name,
                            Colors.white,
                            isDetail: true,
                          ),
                        ),
                ),
              ),
            ),
          ),

          // --- BOTTOM SECTION: INFO CARD ---
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      shape.name,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: shape.color,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Stats Row (Sides & Corners)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatBox('Sides', shape.sides, shape.color),
                        _buildStatBox('Corners', shape.corners, shape.color),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Description
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "About ${shape.name}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            shape.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}

/// --------------------------------------------------
/// UNIFIED SHAPE PAINTER (Handles all 2D shapes)
/// --------------------------------------------------
class ShapePainter extends CustomPainter {
  final String shape;
  final Color color;
  final bool isDetail;

  ShapePainter(this.shape, this.color, {this.isDetail = false});

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Optional: Add a stroke (outline) for the detail view to make it pop
    final strokePaint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = isDetail ? 0 : 3
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    // Detail view uses more space
    final double radius = isDetail ? size.width * 0.45 : size.width * 0.35;

    Path path = Path();

    switch (shape) {
      case 'Circle':
        canvas.drawCircle(center, radius, fillPaint);
        if (!isDetail) canvas.drawCircle(center, radius, strokePaint);
        return; // Return early as circle doesn't use path

      case 'Square':
        final rect = Rect.fromCenter(
          center: center,
          width: radius * 1.8,
          height: radius * 1.8,
        );
        // Rounded rect for kid friendliness
        path.addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(12)));
        break;

      case 'Rectangle':
        final rect = Rect.fromCenter(
          center: center,
          width: radius * 2.2,
          height: radius * 1.4,
        );
        path.addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(12)));
        break;

      case 'Triangle':
        // Equilateral triangle calculation
        final h = radius * math.sqrt(3);
        path.moveTo(center.dx, center.dy - h / 1.5); // Top
        path.lineTo(center.dx + radius, center.dy + h / 3); // Bottom Right
        path.lineTo(center.dx - radius, center.dy + h / 3); // Bottom Left
        path.close();
        break;

      case 'Pentagon':
        // Calculate 5 points
        for (int i = 0; i < 5; i++) {
          double angle =
              (math.pi / 2.5 * i) - math.pi / 2; // Start from top (-90 deg)
          double x = center.dx + radius * math.cos(angle);
          double y = center.dy + radius * math.sin(angle);
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        break;

      case 'Star':
        // 5 pointed star
        final double innerRadius = radius * 0.4;
        final double step = math.pi / 5; // 36 degrees

        // Start at top (-90 degrees)
        path.moveTo(
          center.dx + radius * math.cos(-math.pi / 2),
          center.dy + radius * math.sin(-math.pi / 2),
        );

        for (int i = 1; i <= 10; i++) {
          double angle = -math.pi / 2 + step * i;
          double r = (i % 2 == 0)
              ? radius
              : innerRadius; // Alternating outer and inner radius
          path.lineTo(
            center.dx + r * math.cos(angle),
            center.dy + r * math.sin(angle),
          );
        }
        path.close();
        break;

      case 'Heart':
        // Bezier curve heart
        final double width = radius * 2.2;
        final double height = radius * 2.2;

        path.moveTo(center.dx, center.dy + height * 0.25);

        path.cubicTo(
          center.dx + width / 2,
          center.dy - height / 2, // Control point 1
          center.dx + width / 2,
          center.dy + height / 5, // Control point 2
          center.dx,
          center.dy + height * 0.45, // End point (bottom tip)
        );
        path.cubicTo(
          center.dx - width / 2,
          center.dy + height / 5,
          center.dx - width / 2,
          center.dy - height / 2,
          center.dx,
          center.dy + height * 0.25,
        );
        break;

      default:
        // Default to a circle if unknown
        canvas.drawCircle(center, radius, fillPaint);
        return;
    }

    // Draw the calculated path
    canvas.drawPath(path, fillPaint);
    if (!isDetail) canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant ShapePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.shape != shape;
  }
}
