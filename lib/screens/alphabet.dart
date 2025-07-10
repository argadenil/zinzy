import 'package:flutter/material.dart';
import 'package:zinzy/widgets/horizontalCard.dart';

class Alphabet extends StatefulWidget {
  const Alphabet({super.key});

  @override
  State<Alphabet> createState() => _AlphabetState();
}

class _AlphabetState extends State<Alphabet> {
  List<double> _saturationMatrix(double saturation) {
    final double invSat = 1 - saturation;
    final double r = 0.213 * invSat;
    final double g = 0.715 * invSat;
    final double b = 0.072 * invSat;

    return <double>[
      r + saturation,
      g,
      b,
      0,
      0,
      r,
      g + saturation,
      b,
      0,
      0,
      r,
      g,
      b + saturation,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background with saturation
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.matrix(_saturationMatrix(1.5)),
              child: Image.asset(
                'assets/images/alphabet_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate dynamic sizes
                final isSmallScreen = constraints.maxWidth < 400;
                final imageSize = isSmallScreen ? 40.0 : 60.0;
                final fontSize = isSmallScreen ? 30.0 : 30.0;
                final cardHeight = isSmallScreen ? 120.0 : 150.0;

                return Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back Button
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Image.asset(
                            'assets/images/back_button.png',
                            width: isSmallScreen ? 60 : 80,
                            height: isSmallScreen ? 60 : 80,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 10 : 20),

                        // Card Row
                        SizedBox(
                          height: cardHeight,
                          child: Row(
                            children: [
                              // Card 1
                              Expanded(
                                flex: 2,
                                child: Card(
                                  color: const Color(0xff18a68b),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/cat.png',
                                          width: imageSize,
                                          height: imageSize,
                                          fit: BoxFit.contain,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "A",
                                          style: TextStyle(
                                            color: const Color(0xfffffcc9),
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: Card(
                                  color: const Color(0xff18a68b),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Transform.scale(
                                          scale: 2,
                                          child: Image.asset(
                                            'assets/images/pencil.png',
                                            width: imageSize,
                                            height: imageSize,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Tracing",
                                          style: TextStyle(
                                            color: const Color(0xfffffcc9),
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.bold,
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
