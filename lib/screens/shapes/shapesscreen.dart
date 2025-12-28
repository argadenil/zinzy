import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

/// -------------------------------
/// DATA MODEL
/// -------------------------------
class ShapeItem {
  final String name;
  final String description;
  final String? asset;
  final bool is3D;

  ShapeItem({
    required this.name,
    required this.description,
    this.asset,
    bool? is3D,
  }) : is3D = is3D ?? false;
}

/// -------------------------------
/// SHAPES DATA (Class 1–4)
/// -------------------------------
final List<ShapeItem> shapesList = [
  // 🔵 2D SHAPES
  ShapeItem(
    name: 'Circle',
    description: 'A circle is a round 2D shape. It has no corners.',
    is3D: false,
  ),
  ShapeItem(
    name: 'Square',
    description: 'A square has 4 equal sides and 4 corners.',
    is3D: false,
  ),
  ShapeItem(
    name: 'Rectangle',
    description:
        'A rectangle has 4 sides and 4 corners. Opposite sides are equal.',
    is3D: false,
  ),
  ShapeItem(
    name: 'Triangle',
    description: 'A triangle has 3 sides and 3 corners.',
    is3D: false,
  ),

  // 🔷 3D SHAPES
  ShapeItem(
    name: 'Cube',
    description: 'A cube is a 3D shape with 6 equal square faces.',
    asset: 'assets/shapes/cube.glb',
    is3D: true,
  ),
  ShapeItem(
    name: 'Sphere',
    description: 'A sphere is round like a ball. It has no edges or corners.',
    asset: 'assets/shapes/sphere.glb',
    is3D: true,
  ),
  ShapeItem(
    name: 'Cone',
    description: 'A cone has one circular base and a pointed top.',
    asset: 'assets/shapes/cone.glb',
    is3D: true,
  ),
  ShapeItem(
    name: 'Cylinder',
    description: 'A cylinder has two circular faces and one curved surface.',
    asset: 'assets/shapes/cylinder.glb',
    is3D: true,
  ),
];

/// -------------------------------
/// SHAPES HOME SCREEN
/// -------------------------------
class ShapesScreen extends StatelessWidget {
  const ShapesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shapes'), centerTitle: true),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: shapesList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final shape = shapesList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShapeDetailScreen(shape: shape),
                ),
              );
            },
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  shape.is3D
                      ? const Icon(
                          Icons.view_in_ar,
                          size: 48,
                          color: Colors.deepPurple,
                        )
                      : const Icon(
                          Icons.category,
                          size: 48,
                          color: Colors.orange,
                        ),
                  const SizedBox(height: 12),
                  Text(
                    shape.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

/// -------------------------------
/// SHAPE DETAIL SCREEN
/// -------------------------------
class ShapeDetailScreen extends StatelessWidget {
  final ShapeItem shape;

  const ShapeDetailScreen({super.key, required this.shape});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(shape.name), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 16),

          /// 🔷 SHAPE VIEW
          AspectRatio(
            aspectRatio: 1,
            child: shape.is3D
                ? Flutter3DViewer(src: shape.asset!, enableTouch: true)
                : _TwoDShapeView(shapeName: shape.name),
          ),

          const SizedBox(height: 16),

          /// 📘 SHAPE INFO
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  shape.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// -------------------------------
/// 2D SHAPES DRAWING
/// -------------------------------
class _TwoDShapeView extends StatelessWidget {
  final String shapeName;

  const _TwoDShapeView({required this.shapeName});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ShapePainter(shapeName), child: Container());
  }
}

class _ShapePainter extends CustomPainter {
  final String shape;

  _ShapePainter(this.shape);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final w = size.width * 0.6;
    final h = size.height * 0.6;

    switch (shape) {
      case 'Circle':
        canvas.drawCircle(center, w / 2, paint);
        break;
      case 'Square':
        canvas.drawRect(
          Rect.fromCenter(center: center, width: w, height: w),
          paint,
        );
        break;
      case 'Rectangle':
        canvas.drawRect(
          Rect.fromCenter(center: center, width: w, height: h),
          paint,
        );
        break;
      case 'Triangle':
        final path = Path()
          ..moveTo(center.dx, center.dy - h / 2)
          ..lineTo(center.dx - w / 2, center.dy + h / 2)
          ..lineTo(center.dx + w / 2, center.dy + h / 2)
          ..close();
        canvas.drawPath(path, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
