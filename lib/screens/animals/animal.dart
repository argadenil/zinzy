import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AnimalScreen extends StatefulWidget {
  const AnimalScreen({super.key});

  @override
  State<AnimalScreen> createState() => _AnimalScreenState();
}

class _AnimalScreenState extends State<AnimalScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, String>> _animals = [
    {'name': 'Cat', 'image': 'assets/images/animals/cat.png', 'sound': 'cat.mp3'},
    {'name': 'Dog', 'image': 'assets/images/animals/dog.png', 'sound': 'dog.mp3'},
    {'name': 'Lion', 'image': 'assets/images/animals/lion.png', 'sound': 'lion.mp3'},
    {'name': 'Elephant', 'image': 'assets/images/animals/elephant.png', 'sound': 'elephant.mp3'},
    {'name': 'Tiger', 'image': 'assets/images/animals/tiger.png', 'sound': 'tiger.mp3'},
    {'name': 'Monkey', 'image': 'assets/images/animals/monkey.png', 'sound': 'monkey.mp3'},
    {'name': 'Giraffe', 'image': 'assets/images/animals/giraffe.png', 'sound': 'giraffe.mp3'},
    {'name': 'Zebra', 'image': 'assets/images/animals/zebra.png', 'sound': 'zebra.mp3'},
  ];

  List<double> _saturationMatrix(double saturation) {
    final invSat = 1 - saturation;
    final r = 0.213 * invSat;
    final g = 0.715 * invSat;
    final b = 0.072 * invSat;

    return <double>[
      r + saturation, g, b, 0, 0,
      r, g + saturation, b, 0, 0,
      r, g, b + saturation, 0, 0,
      0, 0, 0, 1, 0,
    ];
  }

  Future<void> _playAnimalSound(String fileName) async {
    try {
      await _audioPlayer.play(AssetSource('audio/$fileName'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.matrix(_saturationMatrix(1.4)),
              child: Image.asset(
                'assets/images/alphabet_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Back button and title
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          'assets/images/back_button.png',
                          width: 60,
                          height: 60,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Learn Animals',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Animal Grid
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1,
                      children: _animals.map((animal) {
                        return GestureDetector(
                          onTap: () => _playAnimalSound(animal['sound']!),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: Offset(4, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.asset(
                                      animal['image']!,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) => Icon(Icons.image, size: 60),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    animal['name']!,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
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
}
