import 'package:flutter/material.dart';
import 'package:zinzy/screens/shapes/shapesScreen.dart';
import 'package:zinzy/screens/shapes/shapesList.dart';


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