import 'dart:ui';

import 'package:flutter/material.dart';

class ShapeItem {
  final String name;
  final String description;
  final String simpleFact; // Short text like "Round!" or "4 Sides"
  final List<ShapeFormula> formulas;
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
    required this.formulas,
    this.asset,
    this.is3D = false,
  });
}

class ShapeFormula {
  final String title;
  final String formula;


  ShapeFormula({
    required this.title,
    required this.formula,
  });
}
