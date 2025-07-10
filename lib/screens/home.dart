import 'package:flutter/material.dart';
import 'package:zinzy/screens/alphabet.dart';
import 'package:zinzy/widgets/card.dart';
import 'package:zinzy/widgets/cloud.dart';
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
          AnimatedClouds(screenWidth: screenWidth, screenHeight: screenHeight),
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
                    borderColor: const Color(0xff3c2815),
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
                                  backgroundColor: const Color(0xff0d5ea6),
                                  borderColor: const Color(0xff3c2815),
                                  fontSize: cardSize * 0.25,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Alphabet(),
                                      ),
                                    );
                                  },
                                ),
                                buildUniformCard(
                                  content: Transform.scale(
                                    scale: 2,
                                    child: Image.asset(
                                      'assets/images/numbers.png',
                                      width: cardSize * 0.5,
                                      height: cardSize * 0.5,
                                    ),
                                  ),
                                  label: 'Numbers',
                                  backgroundColor: const Color(0xffFF7043),
                                  borderColor: const Color(0xff3c2815),

                                  fontSize: cardSize * 0.25,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Alphabet(),
                                      ),
                                    );
                                  },
                                ),
                                buildUniformCard(
                                  content: Transform.scale(
                                    scale: 2,
                                    child: Image.asset(
                                      'assets/images/alphabet.png',
                                      width: cardSize * 0.5,
                                      height: cardSize * 0.5,
                                    ),
                                  ),
                                  label: 'Alphabet',
                                  backgroundColor: const Color(0xff0ead69),
                                  borderColor: const Color(0xff3c2815),
                                  fontSize: cardSize * 0.25,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Alphabet(),
                                      ),
                                    );
                                  },
                                ),
                                buildUniformCard(
                                  content: Transform.scale(
                                    scale: 2,
                                    child: Image.asset(
                                      'assets/images/colors.png',
                                      width: cardSize * 0.5,
                                      height: cardSize * 0.5,
                                    ),
                                  ),
                                  label: 'Colors',
                                  backgroundColor: const Color(0xffc32501),
                                  borderColor: const Color(0xff3c2815),
                                  fontSize: cardSize * 0.25,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Alphabet(),
                                      ),
                                    );
                                  },
                                ),
                                buildUniformCard(
                                  content: Transform.scale(
                                    scale: 2,
                                    child: Image.asset(
                                      'assets/images/science.png',
                                      width: cardSize * 0.5,
                                      height: cardSize * 0.5,
                                    ),
                                  ),
                                  label: 'Science',
                                  backgroundColor: const Color(0xfffda503),
                                  borderColor: const Color(0xff3c2815),
                                  fontSize: cardSize * 0.25,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Alphabet(),
                                      ),
                                    );
                                  },
                                ),
                                buildUniformCard(
                                  content: Transform.scale(
                                    scale: 2,
                                    child: Image.asset(
                                      'assets/images/games.png',
                                      width: cardSize * 0.5,
                                      height: cardSize * 0.5,
                                    ),
                                  ),
                                  label: 'Games',
                                  backgroundColor: const Color(0xfffa6f15),
                                  borderColor: const Color(0xff3c2815),
                                  fontSize: cardSize * 0.25,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Alphabet(),
                                      ),
                                    );
                                  },
                                ),
                                buildUniformCard(
                                  content: Transform.scale(
                                    scale: 2,
                                    child: Image.asset(
                                      'assets/images/music.png',
                                      width: cardSize * 0.5,
                                      height: cardSize * 0.5,
                                    ),
                                  ),
                                  label: 'Music',
                                  backgroundColor: const Color(0xffBA68C8),
                                  borderColor: const Color(0xff3c2815),
                                  fontSize: cardSize * 0.25,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Alphabet(),
                                      ),
                                    );
                                  },
                                ),
                                buildUniformCard(
                                  content: Transform.scale(
                                    scale: 2,
                                    child: Image.asset(
                                      'assets/images/shapes.png',
                                      width: cardSize * 0.5,
                                      height: cardSize * 0.5,
                                    ),
                                  ),
                                  label: 'Shapes',
                                  backgroundColor: const Color(0xff9fb020),
                                  borderColor: const Color(0xff3c2815),
                                  fontSize: cardSize * 0.25,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Alphabet(),
                                      ),
                                    );
                                  },
                                ),
                                buildUniformCard(
                                  content: Transform.scale(
                                    scale: 2,
                                    child: Image.asset(
                                      'assets/images/stories.png',
                                      width: cardSize * 0.5,
                                      height: cardSize * 0.5,
                                    ),
                                  ),
                                  label: 'Stories',
                                  backgroundColor: const Color(0xff3d9aab),
                                  borderColor: const Color(0xff3c2815),
                                  fontSize: cardSize * 0.25,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Alphabet(),
                                      ),
                                    );
                                  },
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
              color: Color(0xfffffcc9),
              height: 1.0, // Keeps vertical centering crisp
            ),
          ),
        ),
      ),
    );
  }
}
