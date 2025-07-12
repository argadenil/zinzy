import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AnimalScreen extends StatefulWidget {
  const AnimalScreen({super.key});

  @override
  State<AnimalScreen> createState() => _AnimalScreenState();
}

class _AnimalScreenState extends State<AnimalScreen> with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _flutterTts = FlutterTts();
  int? _tappedIndex;

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

  Future<void> _playAnimalSound(String fileName, String animalName) async {
    try {
      await _audioPlayer.stop(); // Stop if playing
      await _audioPlayer.play(AssetSource('audio/animals/$fileName'));
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setPitch(1.2);
      await _flutterTts.speak(animalName);
    } catch (e) {
      print('Error playing sound or TTS: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _flutterTts.stop();
    super.dispose();
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
                          color: Color(0xfffffcc9),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Animal Grid
                  Expanded(
                    child: GridView.builder(
                      itemCount: _animals.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final animal = _animals[index];
                        final isTapped = _tappedIndex == index;

                        return GestureDetector(
                          onTap: () async {
                            setState(() => _tappedIndex = index);
                            await _playAnimalSound(animal['sound']!, animal['name']!);
                            Future.delayed(const Duration(milliseconds: 500), () {
                              if (mounted) setState(() => _tappedIndex = null);
                            });
                          },
                          child: AnimatedScale(
                            scale: isTapped ? 1.1 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.primaries[index % Colors.primaries.length].shade200.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Color(0xff3c2815), width: 5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(4, 6),
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
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.image, size: 60),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      animal['name']!,
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
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
        ],
      ),
    );
  }
}
