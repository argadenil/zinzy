import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:zinzy/screens/shapes/shapeItem.dart';
import 'package:zinzy/screens/shapes/shapePainter.dart';

class ShapeDetailScreen extends StatefulWidget {
  final ShapeItem shape;

  const ShapeDetailScreen({super.key, required this.shape});

  @override
  State<ShapeDetailScreen> createState() => _ShapeDetailScreenState();
}

class _ShapeDetailScreenState extends State<ShapeDetailScreen>
    with SingleTickerProviderStateMixin {
  /// 🔄 Fake 3D rotation
  double _rotX = 0;
  double _rotY = 0;

  late AnimationController _resetController;
  late Animation<double> _resetAnim;

  @override
  void initState() {
    super.initState();

    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _resetAnim = CurvedAnimation(
      parent: _resetController,
      curve: Curves.easeOutBack,
    );

    _resetController.addListener(() {
      setState(() {
        _rotX *= (1 - _resetAnim.value);
        _rotY *= (1 - _resetAnim.value);
      });
    });
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color mainColor = widget.shape.color;
    final Color lighterColor = Color.lerp(mainColor, Colors.white, 0.35)!;
    final Color darkerColor = Color.lerp(mainColor, Colors.black, 0.15)!;

    return Scaffold(
      backgroundColor: mainColor,
      body: Stack(
        children: [
          /// 🌈 GRADIENT BACKGROUND
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [lighterColor, mainColor, darkerColor],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                /// 🔙 BACK BUTTON
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Image.asset(
                        'assets/images/back_button.webp',
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                ),

                /// ================= SHAPE VIEW =================
                Expanded(
                  flex: 9,
                  child: Center(
                    child: Hero(
                      tag: widget.shape.name,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            _rotY += details.delta.dx * 0.01;
                            _rotX -= details.delta.dy * 0.01;
                          });
                        },
                        onPanEnd: (_) {
                          _resetController.forward(from: 0);
                        },
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.0015) // perspective
                            ..rotateX(_rotX)
                            ..rotateY(_rotY),
                          child: Container(
                            width: 260,
                            height: 260,
                            child: widget.shape.is3D
                                ? Flutter3DViewer(
                                    src: widget.shape.asset!,
                                    enableTouch: true,
                                    progressBarColor: Colors.transparent,
                                  )
                                : CustomPaint(
                                    painter: ShapePainter(
                                      widget.shape.name,
                                      Colors.amberAccent,
                                      isDetail: true,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                /// ================= INFO CARD =================
                Expanded(
                  flex: 11,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(48),
                        topRight: Radius.circular(48),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(28, 20, 28, 30),
                      child: Column(
                        children: [
                          /// DRAG HANDLE
                          Container(
                            width: 48,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 20),

                          /// TITLE
                          Text(
                            widget.shape.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: mainColor,
                              letterSpacing: 1.4,
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// DESCRIPTION
                          Text(
                            widget.shape.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Colors.blueGrey[600],
                            ),
                          ),

                          const SizedBox(height: 30),

                          /// FORMULAS
                          if (widget.shape.formulas.isNotEmpty)
                            ...widget.shape.formulas.map(
                              (f) => _buildFormulaCard(f, mainColor),
                            )
                          else
                            _buildNoFormulaState(),
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

  /// 📐 FORMULA CARD
  Widget _buildFormulaCard(ShapeFormula item, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontFamily: 'Courier',
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  item.formula,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline, size: 42, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            "Just remember the shape!",
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
        ],
      ),
    );
  }
}
