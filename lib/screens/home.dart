import 'package:flutter/material.dart';
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
            colors: [
              Color(0xFFFF9B3E), // orange-ish top
              Color(0xFFFFD539), // yellow bottom
            ],
            stops: [0.0, 0.60],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: const [
              LearningCard(
                title: 'Animals',
                icon: Icons.pets,
                backgroundColor: Colors.teal,
                borderColor: Colors.tealAccent,
              ),
              LearningCard(
                title: 'Numbers',
                icon: Icons.looks_3,
                backgroundColor: Colors.lightGreen,
                borderColor: Colors.greenAccent,
              ),
              LearningCard(
                title: 'Alphabet',
                icon: Icons.text_fields,
                backgroundColor: Colors.lightBlue,
                borderColor: Colors.blueAccent,
              ),
              LearningCard(
                title: 'Colors',
                icon: Icons.color_lens,
                backgroundColor: Colors.pinkAccent,
                borderColor: Colors.pink,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
