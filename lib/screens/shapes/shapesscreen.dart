import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

/// --------------------------------------------------
/// DATA MODEL
/// --------------------------------------------------
class ShapeItem {
  final String name;
  final String description;
  final bool is3D;
  final String? asset;

  ShapeItem({
    required this.name,
    required this.description,
    this.asset,
    this.is3D = false,
  });
}

/// --------------------------------------------------
/// SHAPES DATA
/// --------------------------------------------------
final List<ShapeItem> shapesList = [
  ShapeItem(
    name: 'Circle',
    description: 'A circle is round. It has no corners.',
  ),
  ShapeItem(name: 'Square', description: 'A square has 4 equal sides.'),
  ShapeItem(name: 'Rectangle', description: 'A rectangle has 4 sides.'),
  ShapeItem(name: 'Triangle', description: 'A triangle has 3 sides.'),
  ShapeItem(
    name: 'Cube',
    description: 'A cube has 6 square faces.',
    asset: 'assets/shapes/cube.glb',
    is3D: true,
  ),
  ShapeItem(
    name: 'Sphere',
    description: 'A sphere is round like a ball.',
    asset: 'assets/shapes/sphere.glb',
    is3D: true,
  ),
  ShapeItem(
    name: 'Cone',
    description: 'A cone has a pointed top.',
    asset: 'assets/shapes/cone.glb',
    is3D: true,
  ),
  ShapeItem(
    name: 'Cylinder',
    description: 'A cylinder has round ends.',
    asset: 'assets/shapes/cylinder.glb',
    is3D: true,
  ),
];

/// --------------------------------------------------
/// COLOR THEMES
/// --------------------------------------------------
final Map<String, List<Color>> shapeGradients = {
  'Circle': [Colors.pinkAccent, Colors.orangeAccent],
  'Square': [Colors.blueAccent, Colors.cyan],
  'Rectangle': [Colors.green, Colors.lightGreenAccent],
  'Triangle': [Colors.deepPurple, Colors.purpleAccent],
  'Cube': [Colors.indigo, Colors.blue],
  'Sphere': [Colors.teal, Colors.cyan],
  'Cone': [Colors.orange, Colors.deepOrange],
  'Cylinder': [Colors.redAccent, Colors.pink],
};

/// --------------------------------------------------
/// SHAPES SCREEN
/// --------------------------------------------------
class ShapesScreen extends StatelessWidget {
  const ShapesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Fun Shapes 🎨'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: shapesList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 👈 3 per row
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final shape = shapesList[index];
          final colors = shapeGradients[shape.name]!;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShapeDetailScreen(shape: shape),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: colors.last.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// SHAPE IMAGE / ICON
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: shape.is3D
                        ? const Icon(
                            Icons.view_in_ar,
                            size: 40,
                            color: Colors.white,
                          )
                        : CustomPaint(painter: CardShapePainter(shape.name)),
                  ),

                  const SizedBox(height: 8),

                  /// SHAPE NAME
                  Text(
                    shape.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
    final colors = shapeGradients[shape.name]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(shape.name),
        centerTitle: true,
        backgroundColor: colors.first,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          /// SHAPE VIEW
          Container(
            margin: const EdgeInsets.all(16),
            height: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: colors.last.withOpacity(0.4),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: shape.is3D
                  ? Flutter3DViewer(src: shape.asset!, enableTouch: true)
                  : TwoDShapeView(shapeName: shape.name),
            ),
          ),

          /// INFO CARD
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 12),
                ],
              ),
              child: Text(
                shape.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// --------------------------------------------------
/// 2D SHAPE VIEW (DETAIL SCREEN)
/// --------------------------------------------------
class TwoDShapeView extends StatelessWidget {
  final String shapeName;

  const TwoDShapeView({super.key, required this.shapeName});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: ShapePainter(shapeName), child: Container());
  }
}

/// --------------------------------------------------
/// CARD SHAPE PAINTER
/// --------------------------------------------------
class CardShapePainter extends CustomPainter {
  final String shape;

  CardShapePainter(this.shape);

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = Colors.white;
    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final center = Offset(size.width / 2, size.height / 2);
    final w = size.width * 0.6;
    final h = size.height * 0.45;

    switch (shape) {
      case 'Circle':
        canvas.drawCircle(center, w / 2, fill);
        canvas.drawCircle(center, w / 2, stroke);
        break;
      case 'Square':
        final r = Rect.fromCenter(center: center, width: w, height: w);
        canvas.drawRect(r, fill);
        canvas.drawRect(r, stroke);
        break;
      case 'Rectangle':
        final r = Rect.fromCenter(center: center, width: w, height: h);
        canvas.drawRect(r, fill);
        canvas.drawRect(r, stroke);
        break;
      case 'Triangle':
        final path = Path()
          ..moveTo(center.dx, center.dy - h / 2)
          ..lineTo(center.dx - w / 2, center.dy + h / 2)
          ..lineTo(center.dx + w / 2, center.dy + h / 2)
          ..close();
        canvas.drawPath(path, fill);
        canvas.drawPath(path, stroke);
        break;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

/// --------------------------------------------------
/// DETAIL SCREEN SHAPE PAINTER
/// --------------------------------------------------
class ShapePainter extends CustomPainter {
  final String shape;

  ShapePainter(this.shape);

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = Colors.white;
    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    final center = Offset(size.width / 2, size.height / 2);
    final w = size.width * 0.55;
    final h = size.height * 0.55;

    switch (shape) {
      case 'Circle':
        canvas.drawCircle(center, w / 2, fill);
        canvas.drawCircle(center, w / 2, stroke);
        break;
      case 'Square':
        final r = Rect.fromCenter(center: center, width: w, height: w);
        canvas.drawRect(r, fill);
        canvas.drawRect(r, stroke);
        break;
      case 'Rectangle':
        final r = Rect.fromCenter(center: center, width: w, height: h);
        canvas.drawRect(r, fill);
        canvas.drawRect(r, stroke);
        break;
      case 'Triangle':
        final path = Path()
          ..moveTo(center.dx, center.dy - h / 2)
          ..lineTo(center.dx - w / 2, center.dy + h / 2)
          ..lineTo(center.dx + w / 2, center.dy + h / 2)
          ..close();
        canvas.drawPath(path, fill);
        canvas.drawPath(path, stroke);
        break;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
