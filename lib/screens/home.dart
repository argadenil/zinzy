import 'package:flutter/material.dart';
import 'package:zinzy/widgets/horizontalCard.dart';
import '../widgets/learningCard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF9B3E), Color(0xFFFFD539)],
            stops: [0.0, 0.60],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                HorizontalLearningCard(
                  title: 'Top Learning',
                  icon: Icons.man_2_sharp,
                  backgroundColor: Colors.red,
                  borderColor: Colors.redAccent,
                ),
                const SizedBox(height: 16), // Spacing between card and grid
                // GridView section
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(42),
                        ),
                        color: Color(0xff10bca6),
                        elevation: 6,
                        child: Container(
                          margin: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: Color(0xff03a49a), // Inner border color
                              width: 7,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Center(
                                  child: SizedBox(
                                    child: Text(
                                      '🐶',
                                      style: TextStyle(fontSize: 95),
                                    ),
                                  ),
                                ),
                                Text(
                                  'Animals',
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(42),
                        ),
                        color: Color(0xfff85c3d),
                        elevation: 6,
                        child: Container(
                          margin: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: Color(0xffed5030), // Inner border color
                              width: 7,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Center(
                                  child: SizedBox(
                                    child: Text(
                                      '3',
                                      style: TextStyle(
                                        fontSize: 95,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFD539),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  'Animals',
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(42),
                        ),
                        color: Color(0xfffebf15),
                        elevation: 6,
                        child: Container(
                          margin: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: Color(0xfffda90e), // Inner border color
                              width: 7,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Center(
                                  child: SizedBox(
                                    child: Text(
                                      '🐶',
                                      style: TextStyle(fontSize: 95),
                                    ),
                                  ),
                                ),
                                Text(
                                  'Animals',
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(42),
                        ),
                        color: Color(0xff3ebc4e),
                        elevation: 6,
                        child: Container(
                          margin: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: Color(0xff42a839), // Inner border color
                              width: 7,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Center(
                                  child: SizedBox(
                                    child: Text(
                                      '🐶',
                                      style: TextStyle(fontSize: 95),
                                    ),
                                  ),
                                ),
                                Text(
                                  'Animals',
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
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
        ),
      ),
    );
  }
}
