import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive_pkg;
import 'package:zinzy/screens/alphabet/alphabet.dart';
import 'package:zinzy/screens/animals/animal.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => animateCat = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      bottomNavigationBar: BottomAppBar(
        height: screenHeight / 10,
        color: const Color(0xFFFFD539),
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

          // Clouds
          AnimatedClouds(screenWidth: screenWidth, screenHeight: screenHeight),

          // Main UI
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                children: [
                  HorizontalLearningCard(
                    title: 'Categories',
                    backgroundColor: const Color.fromARGB(255, 242, 99, 28),
                    borderColor: const Color(0xff3c2815),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final cardSpacing = 8.0;
                        final cardSize = constraints.maxWidth * 0.4;
                        final charWidth = constraints.maxWidth * 0.5;
                        final cardWidth = (constraints.maxWidth - cardSpacing) / 2;
                        final characterLeft = cardWidth + (cardWidth - charWidth) / 2;

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Animated Cat (Rive)
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 1500),
                              curve: Curves.easeOutBack,
                              left: characterLeft,
                              top: animateCat
                                  ? -charWidth * 0.7
                                  : screenHeight * 0.3,
                              child: SizedBox(
                                width: charWidth,
                                height: charWidth,
                                child: rive_pkg.RiveAnimation.asset(
                                  'assets/images/cat_waving.riv',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            // Grid of Cards
                            GridView.count(
                              padding: const EdgeInsets.only(top: 40),
                              crossAxisCount: 2,
                              crossAxisSpacing: cardSpacing,
                              mainAxisSpacing: cardSpacing,
                              children: [
                                _buildCard('Animals', 'cat.png', const Color(0xff0d5ea6), () => AnimalScreen(), cardSize),
                                _buildCard('Numbers', 'numbers.png', const Color(0xffFF7043), () => Alphabet(), cardSize),
                                _buildCard('Alphabet', 'alphabet.png', const Color(0xff0ead69), () => Alphabet(), cardSize),
                                _buildCard('Colors', 'colors.png', const Color(0xffc32501), () => Alphabet(), cardSize),
                                _buildCard('Science', 'science.png', const Color(0xfffda503), () => Alphabet(), cardSize),
                                _buildCard('Games', 'games.png', const Color(0xfffa6f15), () => Alphabet(), cardSize),
                                _buildCard('Music', 'music.png', const Color(0xffBA68C8), () => Alphabet(), cardSize),
                                _buildCard('Shapes', 'shapes.png', const Color(0xff9fb020), () => Alphabet(), cardSize),
                                _buildCard('Stories', 'stories.png', const Color(0xff3d9aab), () => Alphabet(), cardSize),
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

  // Uniform card builder
  Widget _buildCard(
    String label,
    String image,
    Color bgColor,
    Widget Function() navigateTo,
    double cardSize,
  ) {
    return buildUniformCard(
      content: Transform.scale(
        scale: 2,
        child: Image.asset(
          'assets/images/$image',
          width: cardSize * 0.5,
          height: cardSize * 0.5,
        ),
      ),
      label: label,
      backgroundColor: bgColor,
      borderColor: const Color(0xff3c2815),
      fontSize: cardSize * 0.25,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => navigateTo()),
        );
      },
    );
  }

  // Profile Button
  Widget buildProfileButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth * 0.85,
        height: 75,
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
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
