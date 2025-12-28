
import 'dart:ui';

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