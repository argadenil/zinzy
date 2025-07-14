import 'package:flutter/material.dart';
import 'package:zinzy/widgets/cloud.dart';

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
    {
      'title': 'Number Coloring',
      'icon': Icons.color_lens,
      'color': Color(0xFFab47bc),
    },
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
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final double padding = screenWidth * 0.03;
    final double iconSize = isTablet ? 64 : 48;
    final double fontSize = isTablet ? 20 : 16;
    final double cardHeight = screenWidth * 0.4;

    return Scaffold(
      backgroundColor: const Color(0xFFffbb2d),
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedClouds(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            Column(
              children: [
                // Responsive Number Card Header
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(42),
                    ),
                    color: const Color(0xfff36a1a),
                    elevation: 6,
                    child: Container(
                      height: cardHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Center(
                        child: Text(
                          'Number Activities',
                          style: TextStyle(
                            fontSize: fontSize + 4,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Responsive Grid
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: GridView.builder(
                      itemCount: activities.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isTablet ? 3 : 2,
                        childAspectRatio: isTablet ? 1.1 : 1.2,
                        crossAxisSpacing: padding,
                        mainAxisSpacing: padding,
                      ),
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: activity['color'],
                          child: InkWell(
                            onTap: () {
                              // TODO: Add navigation or audio
                            },
                            child: Padding(
                              padding: EdgeInsets.all(padding),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    activity['icon'],
                                    size: iconSize,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: padding / 2),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
