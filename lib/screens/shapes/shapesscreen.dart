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
          Positioned.fill(child: Container(color: Color(0xFFffc10d))),

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
          // 🎨 MATCH CARD BG WITH SHAPE COLOR
          borderRadius: BorderRadius.circular(30),
          color: shape.color,
          border: Border.all(color: const Color(0xff3c2815), width: 6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),

            /// 🔍 BIGGER ICON AREA
            Container(
              width: 130,
              height: 130,
              alignment: Alignment.center,
              child: CustomPaint(
                size: const Size(120, 120),
                painter: ShapePainter(shape.name, shape.color),
              ),
            ),

            /// 🏷 SHAPE NAME
            Text(
              shape.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xff3c2815),
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
/// UNIFIED SHAPE PAINTER (Handles all 2D shapes & 3D Projections)
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
      ..color = const Color(0xff3c2815)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isDetail ? 0 : 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    // Detail view uses more space
    final double radius = isDetail ? size.width * 0.45 : size.width * 0.35;

    Path path = Path();

    switch (shape) {
      // ---------------- 2D SHAPES (Unchanged) ----------------
      case 'Circle':
        canvas.drawCircle(center, radius, fillPaint);
        if (!isDetail) canvas.drawCircle(center, radius, strokePaint);
        return;
      case 'Square':
        final rect = Rect.fromCenter(
          center: center,
          width: radius * 1.8,
          height: radius * 1.8,
        );
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
        final h = radius * math.sqrt(3);
        path.moveTo(center.dx, center.dy - h / 1.5); // Top
        path.lineTo(center.dx + radius, center.dy + h / 3); // Bottom Right
        path.lineTo(center.dx - radius, center.dy + h / 3); // Bottom Left
        path.close();
        break;
      case 'Oval':
        final rect = Rect.fromCenter(
          center: center,
          width: radius * 2.2,
          height: radius * 1.4,
        );
        path.addOval(rect);
        break;
      case 'Pentagon':
        for (int i = 0; i < 5; i++) {
          double angle = (math.pi / 2.5 * i) - math.pi / 2;
          double x = center.dx + radius * math.cos(angle);
          double y = center.dy + radius * math.sin(angle);
          if (i == 0)
            path.moveTo(x, y);
          else
            path.lineTo(x, y);
        }
        path.close();
        break;
      case 'Hexagon':
        for (int i = 0; i < 6; i++) {
          double angle = (math.pi / 3 * i) - math.pi / 2;
          double x = center.dx + radius * math.cos(angle);
          double y = center.dy + radius * math.sin(angle);
          if (i == 0)
            path.moveTo(x, y);
          else
            path.lineTo(x, y);
        }
        path.close();
        break;
      case 'Heptagon':
        for (int i = 0; i < 7; i++) {
          double angle = (2 * math.pi / 7 * i) - math.pi / 2;
          double x = center.dx + radius * math.cos(angle);
          double y = center.dy + radius * math.sin(angle);
          if (i == 0)
            path.moveTo(x, y);
          else
            path.lineTo(x, y);
        }
        path.close();
        break;
      case 'Octagon':
        for (int i = 0; i < 8; i++) {
          double angle = (math.pi / 4 * i) - math.pi / 2;
          double x = center.dx + radius * math.cos(angle);
          double y = center.dy + radius * math.sin(angle);
          if (i == 0)
            path.moveTo(x, y);
          else
            path.lineTo(x, y);
        }
        path.close();
        break;
      case 'Rhombus':
        path.moveTo(center.dx, center.dy - radius);
        path.lineTo(center.dx + radius, center.dy);
        path.lineTo(center.dx, center.dy + radius);
        path.lineTo(center.dx - radius, center.dy);
        path.close();
        break;
      case 'Parallelogram':
        path.moveTo(center.dx - radius * 0.6, center.dy - radius);
        path.lineTo(center.dx + radius * 1.2, center.dy - radius);
        path.lineTo(center.dx + radius * 0.6, center.dy + radius);
        path.lineTo(center.dx - radius * 1.2, center.dy + radius);
        path.close();
        break;
      case 'Trapezium':
        path.moveTo(center.dx - radius * 1.0, center.dy - radius);
        path.lineTo(center.dx + radius * 1.0, center.dy - radius);
        path.lineTo(center.dx + radius * 0.6, center.dy + radius);
        path.lineTo(center.dx - radius * 0.6, center.dy + radius);
        path.close();
        break;

      // ---------------- 3D SHAPES (Corrected Projections) ----------------
      case 'Cube':
        // Isometric view (Hexagon outline with internal Y)
        final double size3d = radius * 0.9;
        // Outline (Silhouette)
        path.moveTo(center.dx, center.dy - size3d); // Top
        path.lineTo(
          center.dx + size3d * 0.866,
          center.dy - size3d * 0.5,
        ); // Top Right
        path.lineTo(
          center.dx + size3d * 0.866,
          center.dy + size3d * 0.5,
        ); // Bottom Right
        path.lineTo(center.dx, center.dy + size3d); // Bottom
        path.lineTo(
          center.dx - size3d * 0.866,
          center.dy + size3d * 0.5,
        ); // Bottom Left
        path.lineTo(
          center.dx - size3d * 0.866,
          center.dy - size3d * 0.5,
        ); // Top Left
        path.close();

        // Internal lines for 3D effect (The 'Y' shape)
        path.moveTo(center.dx, center.dy);
        path.lineTo(center.dx, center.dy - size3d);
        path.moveTo(center.dx, center.dy);
        path.lineTo(center.dx + size3d * 0.866, center.dy + size3d * 0.5);
        path.moveTo(center.dx, center.dy);
        path.lineTo(center.dx - size3d * 0.866, center.dy + size3d * 0.5);
        break;

      case 'Cuboid':
        // Isometric-ish view (wider cube)
        final double w = radius * 1.2;
        final double h = radius * 0.8;
        final double d = radius * 0.5; // depth offset

        // Front Face
        path.moveTo(center.dx - w + d, center.dy - h + d); // Top Left Back
        path.lineTo(center.dx + w, center.dy - h + d); // Top Right Back
        path.lineTo(center.dx + w, center.dy + h); // Bottom Right Front
        path.lineTo(center.dx - w, center.dy + h); // Bottom Left Front
        path.lineTo(center.dx - w, center.dy - h + 20); // Top Left Front
        path.close(); // Only closes the loop, doesn't look quite right for fill

        // Let's redraw properly as silhouette + internal
        path.reset();

        // Silhouette (Perimeter)
        path.moveTo(center.dx - w, center.dy - h); // Top Left Front
        path.lineTo(center.dx + w * 0.6, center.dy - h); // Top Right Front
        path.lineTo(
          center.dx + w,
          center.dy - h - d,
        ); // Top Right Back (Perspective)
        path.lineTo(center.dx + w, center.dy + h - d); // Bottom Right Back
        path.lineTo(center.dx + w * 0.6, center.dy + h); // Bottom Right Front
        path.lineTo(center.dx - w, center.dy + h); // Bottom Left Front
        path.close();

        // Internal Lines
        path.moveTo(center.dx + w * 0.6, center.dy - h);
        path.lineTo(center.dx + w * 0.6, center.dy + h); // Vertical divider
        path.moveTo(center.dx + w * 0.6, center.dy - h);
        path.lineTo(
          center.dx - w,
          center.dy + h,
        ); // Cross (optional, remove for cleaner look)
        // Actually, let's just do standard box lines
        path.reset();

        // Front Face Rect
        path.addRect(
          Rect.fromCenter(
            center: Offset(center.dx - 10, center.dy + 10),
            width: w * 1.4,
            height: h * 1.4,
          ),
        );

        // Top and Side (Oblique) - Clear path
        path.reset();
        // 1. Front Face
        path.moveTo(center.dx - w * 0.8, center.dy - h * 0.6);
        path.lineTo(center.dx + w * 0.6, center.dy - h * 0.6);
        path.lineTo(center.dx + w * 0.6, center.dy + h * 0.8);
        path.lineTo(center.dx - w * 0.8, center.dy + h * 0.8);
        path.close();

        // 2. Top Face connections
        path.moveTo(center.dx - w * 0.8, center.dy - h * 0.6);
        path.lineTo(center.dx - w * 0.5, center.dy - h * 1.1); // Top Left angle
        path.lineTo(
          center.dx + w * 0.9,
          center.dy - h * 1.1,
        ); // Top Right angle
        path.lineTo(
          center.dx + w * 0.6,
          center.dy - h * 0.6,
        ); // Connect to front

        // 3. Side Face connections
        path.moveTo(center.dx + w * 0.9, center.dy - h * 1.1);
        path.lineTo(center.dx + w * 0.9, center.dy + h * 0.3); // Side Bottom
        path.lineTo(
          center.dx + w * 0.6,
          center.dy + h * 0.8,
        ); // Connect to front bottom
        break;

      case 'Sphere':
        final Paint spherePaint = Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.white.withOpacity(0.5), // Brightest spot (Highlight)
              color, // The actual shape color
              Color.lerp(color, Colors.black, 0.35)!, // Darker shadow side
            ],
            stops: const [0.0, 0.4, 1.0],
            center: const Alignment(-0.5, -0.5),
            radius: 1.2,
          ).createShader(Rect.fromCircle(center: center, radius: radius));

        // Draw the main sphere body
        canvas.drawCircle(center, radius, spherePaint);

        // 2. Add a glossy reflection (White Oval)
        // This makes it look shiny and distinct from a flat circle
        final Paint shinePaint = Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.fill;

        canvas.save();
        // Position the shine near the top-left
        canvas.translate(center.dx - radius * 0.35, center.dy - radius * 0.35);
        // Rotate it slightly for a natural look
        canvas.rotate(-math.pi / 4);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset.zero,
            width: radius * 0.5,
            height: radius * 0.25,
          ),
          shinePaint,
        );
        canvas.restore();

      case 'Cylinder':
        final double cylW = radius * 1.2;
        final double cylH = radius * 1.6;
        final double ovalH = radius * 0.4;

        // Top Oval
        path.addOval(
          Rect.fromCenter(
            center: Offset(center.dx, center.dy - cylH / 2),
            width: cylW * 2,
            height: ovalH * 2,
          ),
        );

        // Sides & Bottom
        path.moveTo(center.dx - cylW, center.dy - cylH / 2);
        path.lineTo(center.dx - cylW, center.dy + cylH / 2);
        // Bottom Arc (Half oval)
        path.arcToPoint(
          Offset(center.dx + cylW, center.dy + cylH / 2),
          radius: Radius.elliptical(cylW, ovalH),
          clockwise: false,
        );
        path.lineTo(center.dx + cylW, center.dy - cylH / 2);
        // We don't close here normally to keep lines clean, but for fill we should.
        // The fill will handle the internal overlap fine.
        break;

      case 'Cone':
        final double coneW = radius * 1.4;
        final double coneH = radius * 1.8;
        final double coneOvalH = radius * 0.4;

        // Sides
        path.moveTo(center.dx, center.dy - coneH / 2); // Top Apex
        path.lineTo(center.dx - coneW, center.dy + coneH / 2); // Bottom Left

        // Bottom Arc
        path.arcToPoint(
          Offset(center.dx + coneW, center.dy + coneH / 2),
          radius: Radius.elliptical(coneW, coneOvalH),
          clockwise: false,
        );

        path.lineTo(center.dx, center.dy - coneH / 2); // Back to Apex
        break;

      case 'Pyramid':
        // A square pyramid viewed from slightly above/side
        final double pW = radius * 1.3;
        final double pH = radius * 1.5;

        // Silhouette (Big Triangle)
        path.moveTo(center.dx, center.dy - pH); // Apex
        path.lineTo(center.dx + pW, center.dy + pH / 2); // Bottom Right
        path.lineTo(
          center.dx,
          center.dy + pH * 0.8,
        ); // Bottom Center (Base corner)
        path.lineTo(center.dx - pW, center.dy + pH / 2); // Bottom Left
        path.close();

        // Internal Line (The Edge facing us)
        path.moveTo(center.dx, center.dy - pH);
        path.lineTo(center.dx, center.dy + pH * 0.8);
        break;

      case 'Prism':
        // Triangular Prism (Tent shape)
        final double prW = radius * 1.0;
        final double prH = radius * 1.2;
        final double depth = radius * 0.6;

        // Front Triangle
        path.moveTo(center.dx - depth, center.dy - prH); // Front Top
        path.lineTo(
          center.dx - depth - prW,
          center.dy + prH,
        ); // Front Bottom Left
        path.lineTo(
          center.dx - depth + prW,
          center.dy + prH,
        ); // Front Bottom Right
        path.close();

        // Connect to back
        path.moveTo(center.dx - depth, center.dy - prH); // Front Top
        path.lineTo(center.dx + depth * 2, center.dy - prH * 0.8); // Back Top
        path.lineTo(
          center.dx + depth * 2 + prW,
          center.dy + prH * 0.8,
        ); // Back Bottom Right
        path.lineTo(
          center.dx - depth + prW,
          center.dy + prH,
        ); // Front Bottom Right
        break;

      case 'Hemisphere':
        // Dome shape
        final double hW = radius * 1.4;
        final double hH = radius * 1.4;
        final double hOvalH = radius * 0.4;

        // Start at left base
        path.moveTo(center.dx - hW, center.dy + hH / 3);

        // Top Dome Arc
        path.arcToPoint(
          Offset(center.dx + hW, center.dy + hH / 3),
          radius: Radius.circular(hW),
          clockwise: true,
        );

        // Bottom Base Ellipse (Full oval for 3D effect)
        path.addOval(
          Rect.fromCenter(
            center: Offset(center.dx, center.dy + hH / 3),
            width: hW * 2,
            height: hOvalH * 2,
          ),
        );
        break;
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
