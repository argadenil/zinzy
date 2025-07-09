import 'package:flutter/material.dart';
import 'package:zinzy/widgets/horizontalCard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFF9B3E), Color(0xFFFFD539)],
                stops: [0.0, 0.60],
              ),
            ),
          ),

          // Main UI
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  // Horizontal Top Card
                  HorizontalLearningCard(
                    title: 'Top Learning',
                    icon: Icons.man_2_sharp,
                    backgroundColor: const Color.fromARGB(255, 242, 99, 28),
                    borderColor: const Color(0xffb54a18),
                  ),
                  const SizedBox(height: 16),

                  // GridView + character
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final cardSize = constraints.maxWidth * 0.4;
                        final charWidth = constraints.maxWidth * 0.5;
                        final charTopOffset = -charWidth * 0.9;

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Character behind grid
                            Positioned(
                              top: charTopOffset,
                              left:
                                  constraints.maxWidth / 2 - charWidth / 2 + 50,
                              child: Image.asset(
                                'assets/images/cat_standing.png',
                                width: charWidth * 1.5,
                                height: charWidth * 1.5,
                              ),
                            ),

                            // Grid
                            GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              children: [
                                buildUniformCard(
                                  content: Transform.scale(
                                    scale: 2,
                                    child: Image.asset(
                                      'assets/images/cat.png',
                                      width: cardSize * 0.5,
                                      height: cardSize * 0.5,
                                    ),
                                  ),
                                  label: 'Animals',
                                  backgroundColor: const Color(0xff20b2aa),
                                  borderColor: const Color(0xff008080),
                                  fontSize: cardSize * 0.25,
                                ),
                                buildUniformCard(
                                  content: Transform.scale(
                                    scale: 2,
                                    child: Text(
                                      '3',
                                      style: TextStyle(
                                        fontSize: cardSize * 0.4,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFfcbe10),
                                      ),
                                    ),
                                  ),
                                  label: 'Numbers',
                                  backgroundColor: const Color(0xffff4200),
                                  borderColor: const Color(0xffed5030),
                                  fontSize: cardSize * 0.25,
                                ),
                                buildUniformCard(
                                  content: Transform.scale(
                                    scale: 2,
                                    child: Text(
                                      'A',
                                      style: TextStyle(
                                        fontSize: cardSize * 0.4,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1883d9),
                                      ),
                                    ),
                                  ),
                                  label: 'Alphabet',
                                  backgroundColor: const Color(0xfffebf15),
                                  borderColor: const Color(0xfffda90e),
                                  fontSize: cardSize * 0.25,
                                ),
                                buildUniformCard(
                                  content: Container(
                                    width: cardSize * 0.5,
                                    height: cardSize * 0.5,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  label: 'Colors',
                                  backgroundColor: const Color(0xff3ebc4e),
                                  borderColor: const Color(0xff42a839),
                                  fontSize: cardSize * 0.25,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUniformCard({
    required Widget content,
    required String label,
    required Color backgroundColor,
    required Color borderColor,
    required double fontSize,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(42)),
      color: backgroundColor,
      elevation: 6,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: borderColor, width: 7),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: FittedBox(fit: BoxFit.scaleDown, child: content),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
