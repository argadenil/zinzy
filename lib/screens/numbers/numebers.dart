import 'package:flutter/material.dart';
import 'package:zinzy/screens/numbers/subscreens/countObjects.dart';
import 'package:zinzy/screens/numbers/subscreens/fingerCounting.dart';
import 'package:zinzy/screens/numbers/subscreens/numberColoring.dart';
import 'package:zinzy/screens/numbers/subscreens/numberMatching.dart';
import 'package:zinzy/screens/numbers/subscreens/numberPuzzle.dart';
import 'package:zinzy/screens/numbers/subscreens/numberTracing.dart';

class NumbersScreen extends StatelessWidget {
  const NumbersScreen({super.key});

  final List<Map<String, dynamic>> activities = const [
    {'title': 'Number Tracing', 'icon': Icons.edit, 'color': Color(0xFFf36a1a)},
    {
      'title': 'Count the Objects',
      'icon': Icons.countertops,
      'color': Color(0xFFff7043),
    },
    {
      'title': 'Number Matching',
      'icon': Icons.link,
      'color': Color(0xFFef5350),
    },
    // {
    //   'title': 'Number Coloring',
    //   'icon': Icons.color_lens,
    //   'color': Color(0xFFab47bc),
    // },
    {
      'title': 'Number Puzzle',
      'icon': Icons.extension,
      'color': Color(0xFF29b6f6),
    },
    {
      'title': 'Finger Counting',
      'icon': Icons.back_hand,
      'color': Color(0xFF66bb6a),
    },
    {
      'title': 'Number Ordering',
      'icon': Icons.sort,
      'color': Color(0xFFffa726),
    },
    {
      'title': 'Addition & Subtraction',
      'icon': Icons.add_chart,
      'color': Color(0xFF26c6da),
    },
    {
      'title': 'Songs & Rhymes',
      'icon': Icons.music_note,
      'color': Color(0xFFec407a),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final double mainPadding = isTablet ? 24 : 16;
    final double iconSize = isTablet ? 64 : 48;
    final double fontSize = isTablet ? 20 : 16;

    return Scaffold(
      backgroundColor: const Color(0xFFffbb2d),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(mainPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// BACK BUTTON
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    'assets/images/back_button.png',
                    width: isTablet ? 80 : 60,
                    height: isTablet ? 80 : 60,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// MAIN GRID
              Expanded(
                child: GridView.builder(
                  itemCount: activities.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isTablet ? 3 : 2,
                    childAspectRatio: isTablet ? 1.05 : 1.1,
                    crossAxisSpacing: mainPadding,
                    mainAxisSpacing: mainPadding,
                  ),
                  itemBuilder: (context, index) {
                    final activity = activities[index];

                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(
                          color: const Color(0xff3c2815),
                          width: 7,
                        ),
                      ),
                      color: activity['color'],
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          switch (activity['title']) {
                            case 'Number Tracing':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      NumberTracingScreen(number: 1),
                                ),
                              );
                              break;
                            case 'Count the Objects':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CountObjectsScreen(),
                                ),
                              );
                              break;
                              case 'Number Matching':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NumberMatchingScreen(),
                                ),
                              );
                              break;
                              case 'Number Puzzle':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>  ModernNumberPuzzleScreen(),
                                ),
                              );
                              break;
                              case 'Finger Counting':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FingerCountingPage(),
                                ),
                              );
                              break;
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(mainPadding * 0.8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                activity['icon'],
                                size: iconSize,
                                color: Colors.white,
                              ),
                              SizedBox(height: mainPadding * 0.5),
                              Text(
                                activity['title'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
