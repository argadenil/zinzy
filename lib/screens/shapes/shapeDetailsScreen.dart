import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:zinzy/screens/shapes/shapeItem.dart';
import 'package:zinzy/screens/shapes/shapesscreen.dart';

class ShapeDetailScreen extends StatefulWidget {
  final ShapeItem shape;

  const ShapeDetailScreen({super.key, required this.shape});

  @override
  State<ShapeDetailScreen> createState() => _ShapeDetailScreenState();
}

class _ShapeDetailScreenState extends State<ShapeDetailScreen> {
  @override
  void initState() {
    super.initState();
    print('@@@ start');
    for (var f in widget.shape.formulas ?? []) {
      print('Formula: ${f.title} = ${f.formula}');
    }
    print('@@@ end');
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

          /// 🎨 SUBTLE DECOR ELEMENTS
          Positioned(
            top: -60,
            right: -60,
            child: CircleAvatar(
              radius: 110,
              backgroundColor: Colors.white.withOpacity(0.08),
            ),
          ),
          Positioned(
            top: 120,
            left: -40,
            child: CircleAvatar(
              radius: 70,
              backgroundColor: Colors.white.withOpacity(0.05),
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
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.35),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),

                /// --- SHAPE VIEW ---
                Expanded(
                  flex: 9,
                  child: Center(
                    child: Hero(
                      tag: widget.shape.name,
                      child: Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: darkerColor.withOpacity(0.35),
                              blurRadius: 28,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: widget.shape.is3D
                            ? Flutter3DViewer(
                                src: widget.shape.asset!,
                                enableTouch: true,
                                progressBarColor: Colors.transparent,
                              )
                            : CustomPaint(
                                painter: ShapePainter(
                                  widget.shape.name,
                                  Colors.white,
                                  isDetail: true,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),

                /// --- INFO CARD ---
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: Offset(0, -6),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(28, 12, 28, 30),
                      child: Column(
                        children: [
                          /// DRAG HANDLE
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 16),
                            width: 48,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

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

                          const SizedBox(height: 14),

                          /// DESCRIPTION
                          Text(
                            widget.shape.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.5,
                              height: 1.6,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey[600],
                            ),
                          ),

                          const SizedBox(height: 32),

                          /// FORMULA HEADER
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: mainColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.functions_rounded,
                                  color: mainColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Math Formulas",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.blueGrey[800],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// FORMULA LIST
                          if (widget.shape.formulas != null &&
                              widget.shape.formulas!.isNotEmpty)
                            ...widget.shape.formulas!.map(
                              (f) => _buildFormulaCard(f, mainColor),
                            )
                          else
                            _buildNoFormulaState(),

                          const SizedBox(height: 30),
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.12),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 52,
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
                  (item.title ?? '').toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.formula,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Courier',
                    color: Colors.blueGrey[900],
                  ),
                ),
              ],
            ),
          ),

          Opacity(
            opacity: 0.08,
            child: Icon(
              Icons.calculate,
              color: color,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoFormulaState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Icon(Icons.check_circle_outline,
              size: 40, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            "Just remember the shape!",
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
