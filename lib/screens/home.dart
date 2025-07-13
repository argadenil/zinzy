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
        height: screenHeight * 0.1,
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
          AnimatedClouds(screenWidth: screenWidth, screenHeight: screenHeight),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(5),
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
                        final cardSpacing = 5.0;
                        final cardSize = constraints.maxWidth * 0.4;
                        final charWidth = constraints.maxWidth * 0.5;
                        final cardWidth =
                            (constraints.maxWidth - cardSpacing) / 2;
                        final characterLeft =
                            cardWidth + (cardWidth - charWidth) / 2;

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 2000),
                              curve: Curves.easeOutBack,
                              left: characterLeft,
                              top: animateCat
                                  ? -charWidth * 0.85
                                  : screenHeight * 0.35,
                              child: SizedBox(
                                width: 220,
                                height: 220,
                                child: rive_pkg.RiveAnimation.asset(
                                  'assets/images/cat_waving.riv',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            GridView.builder(
                              padding: const EdgeInsets.all(8),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: screenWidth < 600 ? 2 : 3,
                                    crossAxisSpacing: cardSpacing,
                                    mainAxisSpacing: cardSpacing,
                                    childAspectRatio: 1,
                                  ),
                              itemCount: 9,
                              itemBuilder: (context, index) {
                                final items = [
                                  {
                                    "label": "Animals",
                                    "img": "assets/images/cat.png",
                                    "bg": const Color(0xff0d5ea6),
                                    "route": const AnimalScreen(),
                                  },
                                  {
                                    "label": "Numbers",
                                    "img": "assets/images/numbers.png",
                                    "bg": const Color(0xffFF7043),
                                    "route": const Alphabet(),
                                  },
                                  {
                                    "label": "Alphabet",
                                    "img": "assets/images/alphabet.png",
                                    "bg": const Color(0xff0ead69),
                                    "route": const Alphabet(),
                                  },
                                  {
                                    "label": "Colors",
                                    "img": "assets/images/colors.png",
                                    "bg": const Color(0xffc32501),
                                    "route": const Alphabet(),
                                  },
                                  {
                                    "label": "Science",
                                    "img": "assets/images/science.png",
                                    "bg": const Color(0xfffda503),
                                    "route": const Alphabet(),
                                  },
                                  {
                                    "label": "Games",
                                    "img": "assets/images/games.png",
                                    "bg": const Color(0xfffa6f15),
                                    "route": const Alphabet(),
                                  },
                                  {
                                    "label": "Music",
                                    "img": "assets/images/music.png",
                                    "bg": const Color(0xffBA68C8),
                                    "route": const Alphabet(),
                                  },
                                  {
                                    "label": "Shapes",
                                    "img": "assets/images/shapes.png",
                                    "bg": const Color(0xff9fb020),
                                    "route": const Alphabet(),
                                  },
                                  {
                                    "label": "Stories",
                                    "img": "assets/images/stories.png",
                                    "bg": const Color(0xff3d9aab),
                                    "route": const Alphabet(),
                                  },
                                ];

                                final item = items[index];

                                return buildUniformCard(
                                  content: Transform.scale(
                                    scale: screenWidth < 400 ? 1.6 : 2.0,
                                    child: Image.asset(
                                      item["img"] as String,
                                      width: cardSize * 0.5,
                                      height: cardSize * 0.5,
                                    ),
                                  ),
                                  label: item["label"] as String,
                                  backgroundColor: item["bg"] as Color,
                                  borderColor: const Color(0xff3c2815),
                                  fontSize: cardSize * 0.22,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => item["route"] as Widget,
                                      ),
                                    );
                                  },
                                );
                              },
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
        height: 75,
        decoration: BoxDecoration(
          color: const Color(0xFF815bdf),
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
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
