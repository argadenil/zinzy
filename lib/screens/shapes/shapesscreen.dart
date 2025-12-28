import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:zinzy/screens/shapes/shapeCard.dart';
import 'dart:math' as math;

import 'package:zinzy/screens/shapes/shapesList.dart';

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


class ShapePainter extends CustomPainter {
  final String shape;
  final Color color;
  final bool isDetail;

  ShapePainter(this.shape, this.color, {this.isDetail = false});

  @override
  void paint(Canvas canvas, Size size) {
    // ------------------------------------------------
    // 🎨 COMMON PAINTS
    // ------------------------------------------------
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Dark Border Paint
    final strokePaint = Paint()
      ..color = const Color(0xff3c2815)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isDetail ? 0 : 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 💡 LIGHTING PALETTE (Auto-generated from base color)
    // 1. Highlight (Top faces)
    final Paint lightPaint = Paint()
      ..color = Color.lerp(Colors.white, color, 0.4)!
      ..style = PaintingStyle.fill;

    // 2. Medium/Base (Front faces)
    final Paint basePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 3. Shadow (Side/Bottom faces)
    final Paint darkPaint = Paint()
      ..color = Color.lerp(Colors.black, color, 0.6)!
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final double radius = isDetail ? size.width * 0.45 : size.width * 0.35;

    // Path used for the Outline (Border)
    Path outlinePath = Path();

    // ------------------------------------------------
    // 📐 SHAPE DRAWING LOGIC
    // ------------------------------------------------
    switch (shape) {
      // ==============================================
      // 2D SHAPES (Simple Flat Fills)
      // ==============================================
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
        outlinePath.addRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(12)),
        );
        canvas.drawPath(outlinePath, fillPaint);
        break;
      case 'Rectangle':
        final rect = Rect.fromCenter(
          center: center,
          width: radius * 2.2,
          height: radius * 1.4,
        );
        outlinePath.addRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(12)),
        );
        canvas.drawPath(outlinePath, fillPaint);
        break;
      case 'Triangle':
        final h = radius * math.sqrt(3);
        outlinePath.moveTo(center.dx, center.dy - h / 1.5);
        outlinePath.lineTo(center.dx + radius, center.dy + h / 3);
        outlinePath.lineTo(center.dx - radius, center.dy + h / 3);
        outlinePath.close();
        canvas.drawPath(outlinePath, fillPaint);
        break;
      case 'Oval':
        final rect = Rect.fromCenter(
          center: center,
          width: radius * 2.2,
          height: radius * 1.4,
        );
        outlinePath.addOval(rect);
        canvas.drawPath(outlinePath, fillPaint);
        break;
      case 'Pentagon':
      case 'Hexagon':
      case 'Heptagon':
      case 'Octagon':
        int sides = 5;
        if (shape == 'Hexagon') sides = 6;
        if (shape == 'Heptagon') sides = 7;
        if (shape == 'Octagon') sides = 8;

        for (int i = 0; i < sides; i++) {
          double angle = (2 * math.pi / sides * i) - math.pi / 2;
          double x = center.dx + radius * math.cos(angle);
          double y = center.dy + radius * math.sin(angle);
          if (i == 0)
            outlinePath.moveTo(x, y);
          else
            outlinePath.lineTo(x, y);
        }
        outlinePath.close();
        canvas.drawPath(outlinePath, fillPaint);
        break;
      case 'Rhombus':
        outlinePath.moveTo(center.dx, center.dy - radius);
        outlinePath.lineTo(center.dx + radius, center.dy);
        outlinePath.lineTo(center.dx, center.dy + radius);
        outlinePath.lineTo(center.dx - radius, center.dy);
        outlinePath.close();
        canvas.drawPath(outlinePath, fillPaint);
        break;
      case 'Parallelogram':
        outlinePath.moveTo(center.dx - radius * 0.6, center.dy - radius);
        outlinePath.lineTo(center.dx + radius * 1.2, center.dy - radius);
        outlinePath.lineTo(center.dx + radius * 0.6, center.dy + radius);
        outlinePath.lineTo(center.dx - radius * 1.2, center.dy + radius);
        outlinePath.close();
        canvas.drawPath(outlinePath, fillPaint);
        break;
      case 'Trapezium':
        outlinePath.moveTo(center.dx - radius * 1.0, center.dy - radius);
        outlinePath.lineTo(center.dx + radius * 1.0, center.dy - radius);
        outlinePath.lineTo(center.dx + radius * 0.6, center.dy + radius);
        outlinePath.lineTo(center.dx - radius * 0.6, center.dy + radius);
        outlinePath.close();
        canvas.drawPath(outlinePath, fillPaint);
        break;

      // ==============================================
      // 3D SHAPES (Shaded Faces + Gradients)
      // ==============================================

      case 'Cube':
        final double s = radius * 0.9;

        // 1. TOP FACE (Lightest)
        Path topFace = Path();
        topFace.moveTo(center.dx, center.dy - s);
        topFace.lineTo(center.dx + s * 0.866, center.dy - s * 0.5);
        topFace.lineTo(center.dx, center.dy);
        topFace.lineTo(center.dx - s * 0.866, center.dy - s * 0.5);
        topFace.close();
        canvas.drawPath(topFace, lightPaint);

        // 2. RIGHT FACE (Darkest/Shadow)
        Path rightFace = Path();
        rightFace.moveTo(center.dx, center.dy);
        rightFace.lineTo(center.dx + s * 0.866, center.dy - s * 0.5);
        rightFace.lineTo(center.dx + s * 0.866, center.dy + s * 0.5);
        rightFace.lineTo(center.dx, center.dy + s);
        rightFace.close();
        canvas.drawPath(rightFace, darkPaint);

        // 3. LEFT FACE (Base Color)
        Path leftFace = Path();
        leftFace.moveTo(center.dx, center.dy);
        leftFace.lineTo(center.dx - s * 0.866, center.dy - s * 0.5);
        leftFace.lineTo(center.dx - s * 0.866, center.dy + s * 0.5);
        leftFace.lineTo(center.dx, center.dy + s);
        leftFace.close();
        canvas.drawPath(leftFace, basePaint);

        // 4. OUTLINE (Silhouette + Inner Y)
        outlinePath.addPath(topFace, Offset.zero);
        outlinePath.addPath(rightFace, Offset.zero);
        outlinePath.addPath(leftFace, Offset.zero);
        break;

      case 'Cuboid':
        final double w = radius * 0.9;
        final double h = radius * 0.8;

        // Vertices logic (Oblique view)
        // Front Face Coords
        final flt = Offset(
          center.dx - w,
          center.dy - h * 0.6,
        ); // Front Left Top
        final frt = Offset(
          center.dx + w * 0.6,
          center.dy - h * 0.6,
        ); // Front Right Top
        final frb = Offset(
          center.dx + w * 0.6,
          center.dy + h * 0.8,
        ); // Front Right Bottom
        final flb = Offset(
          center.dx - w,
          center.dy + h * 0.8,
        ); // Front Left Bottom

        // Back/Top Coords
        final blt = Offset(
          center.dx - w * 0.6,
          center.dy - h * 1.1,
        ); // Back Left Top
        final brt = Offset(
          center.dx + w * 1.0,
          center.dy - h * 1.1,
        ); // Back Right Top

        // 1. FRONT FACE (Base)
        Path frontFace = Path()
          ..moveTo(flt.dx, flt.dy)
          ..lineTo(frt.dx, frt.dy)
          ..lineTo(frb.dx, frb.dy)
          ..lineTo(flb.dx, flb.dy)
          ..close();
        canvas.drawPath(frontFace, basePaint);

        // 2. TOP FACE (Light)
        Path topFaceCuboid = Path()
          ..moveTo(flt.dx, flt.dy)
          ..lineTo(blt.dx, blt.dy)
          ..lineTo(brt.dx, brt.dy)
          ..lineTo(frt.dx, frt.dy)
          ..close();
        canvas.drawPath(topFaceCuboid, lightPaint);

        // 3. SIDE FACE (Dark)
        Path sideFace = Path()
          ..moveTo(frt.dx, frt.dy)
          ..lineTo(brt.dx, brt.dy)
          ..lineTo(brt.dx, frb.dy * 0.8)
          ..lineTo(frb.dx, frb.dy)
          ..close();
        canvas.drawPath(sideFace, darkPaint);

        // 4. OUTLINE
        outlinePath.addPath(frontFace, Offset.zero);
        outlinePath.addPath(topFaceCuboid, Offset.zero);
        outlinePath.addPath(sideFace, Offset.zero);
        break;

      case 'Sphere':
        // 1. RADIAL GRADIENT FILL
        final Paint sphereGradient = Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.white.withOpacity(0.9),
              color,
              Color.lerp(color, Colors.black, 0.6)!,
            ],
            stops: const [0.05, 0.4, 1.0],
            center: const Alignment(-0.4, -0.4),
            radius: 1.0,
          ).createShader(Rect.fromCircle(center: center, radius: radius));

        canvas.drawCircle(center, radius, sphereGradient);

        // 2. SHINE (Reflection)
        final Paint shinePaint = Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.fill;
        canvas.save();
        canvas.translate(center.dx - radius * 0.35, center.dy - radius * 0.35);
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

        // 3. BORDER
        if (!isDetail) canvas.drawCircle(center, radius, strokePaint);
        return;

      case 'Cylinder':
        final double cylW = radius * 1.2;
        final double cylH = radius * 1.6;
        final double ovalH = radius * 0.4;

        // 1. BODY (Linear Gradient for roundness)
        final Rect bodyRect = Rect.fromLTWH(
          center.dx - cylW,
          center.dy - cylH / 2,
          cylW * 2,
          cylH,
        );
        final Paint cylBodyPaint = Paint()
          ..shader = LinearGradient(
            colors: [
              Color.lerp(color, Colors.black, 0.3)!,
              color,
              Color.lerp(color, Colors.white, 0.5)!,
              color,
              Color.lerp(color, Colors.black, 0.3)!,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bodyRect);

        Path bodyPath = Path();
        bodyPath.moveTo(center.dx - cylW, center.dy - cylH / 2);
        bodyPath.lineTo(center.dx - cylW, center.dy + cylH / 2);
        bodyPath.arcToPoint(
          Offset(center.dx + cylW, center.dy + cylH / 2),
          radius: Radius.elliptical(cylW, ovalH),
          clockwise: false,
        );
        bodyPath.lineTo(center.dx + cylW, center.dy - cylH / 2);
        bodyPath.close();
        canvas.drawPath(bodyPath, cylBodyPaint);

        // 2. TOP (Light flat oval)
        Rect topRect = Rect.fromCenter(
          center: Offset(center.dx, center.dy - cylH / 2),
          width: cylW * 2,
          height: ovalH * 2,
        );
        canvas.drawOval(topRect, lightPaint);

        // 3. OUTLINE
        // Combine body and top for a clean outline
        outlinePath.addOval(topRect);
        outlinePath.moveTo(center.dx - cylW, center.dy - cylH / 2);
        outlinePath.lineTo(center.dx - cylW, center.dy + cylH / 2);
        outlinePath.arcToPoint(
          Offset(center.dx + cylW, center.dy + cylH / 2),
          radius: Radius.elliptical(cylW, ovalH),
          clockwise: false,
        );
        outlinePath.lineTo(center.dx + cylW, center.dy - cylH / 2);
        break;

      case 'Cone':
        final double coneW = radius * 1.4;
        final double coneH = radius * 1.8;
        final double coneOvalH = radius * 0.4;

        // 1. BODY (Gradient)
        Rect coneRect = Rect.fromLTWH(
          center.dx - coneW,
          center.dy - coneH / 2,
          coneW * 2,
          coneH,
        );
        final Paint coneBodyPaint = Paint()
          ..shader = LinearGradient(
            colors: [
              Color.lerp(color, Colors.black, 0.3)!,
              color,
              Color.lerp(color, Colors.white, 0.5)!,
              color,
              Color.lerp(color, Colors.black, 0.3)!,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(coneRect);

        Path coneBody = Path();
        coneBody.moveTo(center.dx, center.dy - coneH / 2); // Top
        coneBody.lineTo(
          center.dx - coneW,
          center.dy + coneH / 2,
        ); // Bottom Left
        coneBody.arcToPoint(
          Offset(center.dx + coneW, center.dy + coneH / 2),
          radius: Radius.elliptical(coneW, coneOvalH),
          clockwise: false,
        );
        coneBody.close();
        canvas.drawPath(coneBody, coneBodyPaint);

        // 2. OUTLINE
        outlinePath = coneBody;
        break;

      case 'Pyramid':
        final double pW = radius * 1.3;
        final double pH = radius * 1.5;

        // 1. FRONT FACE (Base Color)
        Path frontTri = Path();
        frontTri.moveTo(center.dx, center.dy - pH); // Apex
        frontTri.lineTo(center.dx, center.dy + pH * 0.8); // Base Center
        frontTri.lineTo(center.dx - pW, center.dy + pH / 2); // Bottom Left
        frontTri.close();
        canvas.drawPath(frontTri, basePaint);

        // 2. SIDE FACE (Dark Color - Shadow)
        Path sideTri = Path();
        sideTri.moveTo(center.dx, center.dy - pH); // Apex
        sideTri.lineTo(center.dx + pW, center.dy + pH / 2); // Bottom Right
        sideTri.lineTo(center.dx, center.dy + pH * 0.8); // Base Center
        sideTri.close();
        canvas.drawPath(sideTri, darkPaint);

        // 3. OUTLINE
        outlinePath.addPath(frontTri, Offset.zero);
        outlinePath.addPath(sideTri, Offset.zero);
        break;

      case 'Prism':
        final double prW = radius * 1.0;
        final double prH = radius * 1.2;
        final double depth = radius * 0.6;

        // Coords
        final pTop = Offset(center.dx - depth, center.dy - prH);
        final pBotL = Offset(center.dx - depth - prW, center.dy + prH);
        final pBotR = Offset(center.dx - depth + prW, center.dy + prH);
        final pBackTop = Offset(center.dx + depth * 1.5, center.dy - prH * 0.8);
        final pBackBotR = Offset(
          center.dx + depth * 1.5 + prW,
          center.dy + prH * 0.8,
        );

        // 1. FRONT TRIANGLE (Base)
        Path frontP = Path()
          ..moveTo(pTop.dx, pTop.dy)
          ..lineTo(pBotL.dx, pBotL.dy)
          ..lineTo(pBotR.dx, pBotR.dy)
          ..close();
        canvas.drawPath(frontP, basePaint);

        // 2. SIDE RECT (Dark)
        Path sideP = Path()
          ..moveTo(pTop.dx, pTop.dy)
          ..lineTo(pBackTop.dx, pBackTop.dy)
          ..lineTo(pBackBotR.dx, pBackBotR.dy)
          ..lineTo(pBotR.dx, pBotR.dy)
          ..close();
        canvas.drawPath(sideP, darkPaint);

        // 3. OUTLINE
        outlinePath.addPath(frontP, Offset.zero);
        outlinePath.addPath(sideP, Offset.zero);
        break;

      case 'Hemisphere':
        final double hW = radius * 1.3; // Width
        final double baseLevel =
            center.dy - radius * 0.2; // The top flat surface level
        final double curveHeight =
            radius * 0.3; // Perspective depth of the top oval

        // 1. BODY PATH (The rounded bottom part)
        Path bodyPath = Path();
        bodyPath.moveTo(center.dx - hW, baseLevel);
        // Arc down to the right (The bowl shape)
        bodyPath.arcToPoint(
          Offset(center.dx + hW, baseLevel),
          radius: Radius.circular(hW),
          clockwise: false,
        );
        // Close the loop back to start across the top
        // We use a slight upward curve to match the back of the oval so the fill doesn't leak
        bodyPath.arcToPoint(
          Offset(center.dx - hW, baseLevel),
          radius: Radius.elliptical(hW, curveHeight),
          clockwise: true,
        );
        bodyPath.close();

        // 2. FILL BODY (Darker Radial Gradient)
        final Paint bodyPaint = Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.white.withOpacity(0.9), // Highlight
              color, // Base Color
              Color.lerp(color, Colors.black, 0.6)!, // Shadow
            ],
            stops: const [0.05, 0.4, 1.0],
            center: const Alignment(
              -0.4,
              0.3,
            ), // Light hitting the curved belly
            radius: 1.2,
          ).createShader(Rect.fromCircle(center: center, radius: radius));

        canvas.drawPath(bodyPath, bodyPaint);

        // 3. TOP FACE (The Flat Oval)
        Rect topRect = Rect.fromCenter(
          center: Offset(center.dx, baseLevel),
          width: hW * 2,
          height: curveHeight * 2,
        );

        // Fill Top Face (Lighter because it's flat and catching light)
        canvas.drawOval(topRect, lightPaint);

        // 4. REFLECTION (Shine on the bottom-left of the body)
        final Paint shinePaint = Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.fill;

        canvas.save();
        canvas.translate(center.dx - radius * 0.5, center.dy + radius * 0.5);
        canvas.rotate(math.pi / 6);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset.zero,
            width: radius * 0.4,
            height: radius * 0.15,
          ),
          shinePaint,
        );
        canvas.restore();

        // 5. OUTLINE (Combine Body + Full Top Oval)
        // Add the Top Oval first
        outlinePath.addOval(topRect);

        // Add the Bottom Arc (Outline only needs the bottom curve)
        Path bottomArcOutline = Path();
        bottomArcOutline.moveTo(center.dx - hW, baseLevel);
        bottomArcOutline.arcToPoint(
          Offset(center.dx + hW, baseLevel),
          radius: Radius.circular(hW),
          clockwise: false,
        );
        outlinePath.addPath(bottomArcOutline, Offset.zero);
        break;
    }

    // 🖍 FINAL STEP: Draw the dark border on top of everything
    if (!isDetail && outlinePath.getBounds() != Rect.zero) {
      canvas.drawPath(outlinePath, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant ShapePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.shape != shape;
  }
}
