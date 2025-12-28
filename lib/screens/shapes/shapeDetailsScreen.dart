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
                /// 🔙 CUSTOM BACK BUTTON (IMAGE)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
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
                ),

                /// --- TOP SECTION : SHAPE VIEW ---
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

                /// --- BOTTOM INFO CARD ---
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
                          /// Title
                          Text(
                            shape.name,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: shape.color,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// Stats
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatBox('Sides', shape.sides, shape.color),
                              _buildStatBox(
                                'Corners',
                                shape.corners,
                                shape.color,
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          /// Description Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "ABOUT ${shape.name.toUpperCase()}",
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
          ),
        ],
      ),
    );
  }

  /// 🔢 STAT CIRCLE
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
