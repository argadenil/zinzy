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
  // ---------------- 2D SHAPES ----------------
  ShapeItem(
    name: 'Circle',
    description: 'A circle is round. It has no corners.',
    simpleFact: 'Round!',
    sides: 0,
    corners: 0,
    color: const Color(0xFFFF6F61),
  ),
  ShapeItem(
    name: 'Square',
    description: 'A square has 4 equal sides.',
    simpleFact: '4 Equal Sides',
    sides: 4,
    corners: 4,
    color: const Color(0xFF42A5F5),
  ),
  ShapeItem(
    name: 'Rectangle',
    description: 'A rectangle has 4 sides. Opposite sides are equal.',
    simpleFact: 'Long & Short',
    sides: 4,
    corners: 4,
    color: const Color(0xFF66BB6A),
  ),
  ShapeItem(
    name: 'Triangle',
    description: 'A triangle has 3 sides and 3 corners.',
    simpleFact: '3 Sides',
    sides: 3,
    corners: 3,
    color: const Color(0xFFAB47BC),
  ),
  ShapeItem(
    name: 'Oval',
    description: 'An oval looks like an egg shape.',
    simpleFact: 'Egg Shape',
    sides: 0,
    corners: 0,
    color: const Color(0xFF26C6DA),
  ),
  ShapeItem(
    name: 'Pentagon',
    description: 'A pentagon has 5 sides.',
    simpleFact: '5 Sides',
    sides: 5,
    corners: 5,
    color: const Color(0xFF7E57C2),
  ),
  ShapeItem(
    name: 'Hexagon',
    description: 'A hexagon has 6 sides.',
    simpleFact: '6 Sides',
    sides: 6,
    corners: 6,
    color: const Color(0xFF26A69A),
  ),
  ShapeItem(
    name: 'Heptagon',
    description: 'A heptagon has 7 sides.',
    simpleFact: '7 Sides',
    sides: 7,
    corners: 7,
    color: const Color(0xFFFFA726),
  ),
  ShapeItem(
    name: 'Octagon',
    description: 'An octagon has 8 sides.',
    simpleFact: '8 Sides',
    sides: 8,
    corners: 8,
    color: const Color(0xFFEF5350),
  ),
  ShapeItem(
    name: 'Rhombus',
    description: 'A rhombus has 4 equal slanted sides.',
    simpleFact: 'Diamond Shape',
    sides: 4,
    corners: 4,
    color: const Color(0xFF5C6BC0),
  ),
  ShapeItem(
    name: 'Parallelogram',
    description: 'Opposite sides are parallel.',
    simpleFact: 'Parallel',
    sides: 4,
    corners: 4,
    color: const Color(0xFF8D6E63),
  ),
  ShapeItem(
    name: 'Trapezium',
    description: 'A trapezium has one pair of parallel sides.',
    simpleFact: '1 Parallel Pair',
    sides: 4,
    corners: 4,
    color: const Color(0xFF78909C),
  ),

  // ---------------- 3D SHAPES ----------------
  ShapeItem(
    name: 'Cube',
    description: 'A cube has 6 square faces.',
    simpleFact: 'Box Shape',
    sides: 6,
    corners: 8,
    color: const Color(0xFF5C6BC0),
    asset: 'assets/shapes/cube.glb',
    is3D: true,
  ),
  ShapeItem(
    name: 'Cuboid',
    description: 'A cuboid is a box like a book.',
    simpleFact: 'Box',
    sides: 6,
    corners: 8,
    color: const Color(0xFF42A5F5),
    asset: 'assets/shapes/cuboid.glb',
    is3D: true,
  ),
  ShapeItem(
    name: 'Sphere',
    description: 'A sphere is round like a ball.',
    simpleFact: 'Rolls',
    sides: 0,
    corners: 0,
    color: const Color(0xFFFF7043),
    asset: 'assets/shapes/sphere.glb',
    is3D: true,
  ),
  ShapeItem(
    name: 'Cylinder',
    description: 'A cylinder looks like a tin can.',
    simpleFact: 'Can Shape',
    sides: 3,
    corners: 0,
    color: const Color(0xFF26C6DA),
    asset: 'assets/shapes/cylinder.glb',
    is3D: true,
  ),
  ShapeItem(
    name: 'Cone',
    description: 'A cone looks like an ice-cream cone.',
    simpleFact: 'Pointy Top',
    sides: 2,
    corners: 1,
    color: const Color(0xFFFFA726),
    asset: 'assets/shapes/cone.glb',
    is3D: true,
  ),
  ShapeItem(
    name: 'Pyramid',
    description: 'A pyramid has triangle faces and a square base.',
    simpleFact: 'Egypt Shape',
    sides: 5,
    corners: 5,
    color: const Color(0xFF8D6E63),
    asset: 'assets/shapes/pyramid.glb',
    is3D: true,
  ),
  ShapeItem(
    name: 'Prism',
    description: 'A prism has the same shape on both ends.',
    simpleFact: 'Twin Ends',
    sides: 5,
    corners: 6,
    color: const Color(0xFF7E57C2),
    asset: 'assets/shapes/prism.glb',
    is3D: true,
  ),
  ShapeItem(
    name: 'Hemisphere',
    description: 'A hemisphere is half of a sphere.',
    simpleFact: 'Half Ball',
    sides: 1,
    corners: 0,
    color: const Color(0xFFEC407A),
    asset: 'assets/shapes/hemisphere.glb',
    is3D: true,
  ),
];

/// --------------------------------------------------
/// SHAPES SCREEN (HOME)
/// --------------------------------------------------
/// --------------------------------------------------
/// SHAPES SCREEN (HOME) – FIXED
/// --------------------------------------------------
class ShapesScreen extends StatelessWidget {
  const ShapesScreen({super.key});

  int _crossAxisCount(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w > 900) return 4; // large tablet
    if (w > 600) return 3; // tablet
    return 2; // phone
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          /// 🌈 BACKGROUND IMAGE WITH SATURATION
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.matrix(_saturationMatrix(1.5)),
              child: Image.asset(
                'assets/images/alphabet_bg.webp',
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// 🧩 FOREGROUND CONTENT
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔙 CUSTOM BACK BUTTON
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/images/back_button.webp',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),

                /// 📦 SHAPES GRID
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    itemCount: shapesList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _crossAxisCount(context),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      return ShapeCard(shape: shapesList[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🎨 SATURATION MATRIX
  static List<double> _saturationMatrix(double saturation) {
    final double invSat = 1 - saturation;
    final double r = 0.213 * invSat;
    final double g = 0.715 * invSat;
    final double b = 0.072 * invSat;

    return [
      r + saturation,
      g,
      b,
      0,
      0,
      r,
      g + saturation,
      b,
      0,
      0,
      r,
      g,
      b + saturation,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
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
            const SizedBox(height: 16),
            SizedBox(
              width: 90,
              height: 90,
              child: shape.is3D
                  ? Icon(
                      Icons.view_in_ar_outlined,
                      size: 70,
                      color: shape.color,
                    )
                  : CustomPaint(painter: ShapePainter(shape.name, shape.color)),
            ),
            const SizedBox(height: 12),
            Text(
              shape.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
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
