import 'package:flutter/material.dart';
import 'package:zinzy/widgets/horizontalCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool animateCat = false;

  @override
  void initState() {
    super.initState();
    // Trigger animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        animateCat = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      bottomNavigationBar: BottomAppBar(
        height: screenHeight / 10,
        color: Color(0xFFFFD539),
        child: buildProfileButton(context),
      ),
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
                    title: 'Categories',
                    backgroundColor: const Color.fromARGB(255, 242, 99, 28),
                    borderColor: const Color(0xffb54a18),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final cardSpacing = 5.0;
                        final cardSize = constraints.maxWidth * 0.4;
                        final charWidth = constraints.maxWidth * 0.5;
                        final cardWidth =
                            (constraints.maxWidth - cardSpacing) / 2;

                        // Position character over second card ("Numbers")
                        final characterLeft =
                            cardWidth + (cardWidth - charWidth) / 2;

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Animated cat character
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 2000),
                              curve: Curves.easeOutBack,
                              left: characterLeft,
                              top: animateCat
                                  ? -charWidth * 0.85
                                  : screenHeight * 0.3,
                              child: Image.asset(
                                'assets/images/cat_standing.png',
                                width: charWidth,
                                height: charWidth,
                              ),
                            ),

                            // Grid of cards
                            GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: cardSpacing,
                              mainAxisSpacing: cardSpacing,
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

  Widget buildProfileButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth * 0.85,
        height: 75, // Fixed height for vertical alignment
        decoration: BoxDecoration(
          color: const Color(0xFF815bdf),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Profile',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.0, // Keeps vertical centering crisp
            ),
          ),
        ),
      ),
    );
  }
}
