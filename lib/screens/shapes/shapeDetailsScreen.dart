import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:zinzy/screens/shapes/shapeItem.dart';
import 'package:zinzy/screens/shapes/shapesscreen.dart';

class ShapeDetailScreen extends StatelessWidget {
  final ShapeItem shape;

  const ShapeDetailScreen({super.key, required this.shape});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🌈 BACKGROUND COLOR
          Positioned.fill(child: Container(color: shape.color)),

          SafeArea(
            child: Column(
              children: [
                /// 🔙 CUSTOM BACK BUTTON
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Image.asset(
                          'assets/images/back_button.webp',
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                  ),
                ),

                /// --- TOP SECTION : SHAPE VIEW ---
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Hero(
                      tag: shape.name,
                      child: SizedBox(
                        width: 240,
                        height: 240,
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

                /// --- BOTTOM INFO CARD ---
                Expanded(
                  flex: 6,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(25, 30, 25, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// 🏷️ TITLE
                          Text(
                            shape.name,
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              color: shape.color,
                              letterSpacing: -1,
                            ),
                          ),

                          /// 📝 DESCRIPTION
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              shape.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          Divider(color: Colors.grey[200], thickness: 2),
                          const SizedBox(height: 20),

                          /// 📐 FORMULAS HEADER
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Key Formulas",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          /// ➗ FORMULA LIST
                          if (shape.formulas != null &&
                              shape.formulas!.isNotEmpty)
                            ...shape.formulas!.map(
                              (f) => _buildFormulaCard(f, shape.color),
                            )
                          else
                            _buildNoFormulaState(),

                          // Add padding at bottom for scrolling
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 📐 FORMULA CARD WIDGET
  Widget _buildFormulaCard(ShapeFormula item, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        children: [
          /// Icon Container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.calculate_outlined, color: color, size: 24),
          ),
          const SizedBox(width: 15),

          /// Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color.withOpacity(0.8),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.formula,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Courier', // Monospace for math looks better
                    color: Colors.grey[900],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoFormulaState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        "No formulas needed for this one!",
        style: TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
      ),
    );
  }
}
