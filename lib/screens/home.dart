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
                    children: const [
                      LearningCard(
                        title: 'Animals',
                        icon: Text(
                          'A',
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        backgroundColor: Color(0xff10bca6),
                        borderColor: Color(0xff03a49a),
                      ),
                      LearningCard(
                        title: 'Numbers',
                        icon: Text(
                          '3',
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Color(0xfff85c3d),
                        borderColor: Color(0xffed5030),
                      ),
                      LearningCard(
                        title: 'Alphabet',
                        icon: Text(
                          'A',
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Color(0xfffebf15),
                        borderColor: Color(0xfffda90e),
                      ),
                      LearningCard(
                        title: 'Colors',
                        icon: Text(
                          'A',
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Color(0xff3ebc4e),
                        borderColor: Color(0xff42a839),
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
