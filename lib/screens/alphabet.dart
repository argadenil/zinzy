import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class Alphabet extends StatefulWidget {
  const Alphabet({super.key});

  @override
  State<Alphabet> createState() => _AlphabetState();
}

class _AlphabetState extends State<Alphabet> {
  final List<Color> _kidColors = [
    Color(0xFFf4581a), // F
    Color(0xFF8e49a2), // A
    Color(0xFF77c00d), // B
    Color(0xFF139d86), // C
    Color(0xFFffc10d), // D
    Color(0xFF1b75b5), // E
    Color(0xFFffc10d), // G
    Color(0xFF8e49a2), // H
    Color(0xFFf4581a), // I
    Color(0xFF139d86), // J
    Color(0xFF1b75b5), // K
    Color(0xFF77c00d), // L
    Color(0xFFffc10d), // M
    Color(0xFF8e49a2), // N
    Color(0xFF1b75b5), // O
    Color(0xFFf4581a), // P
    Color(0xFF77c00d), // Q
    Color(0xFF139d86), // R
    Color(0xFFffc10d), // S
    Color(0xFF8e49a2), // T
    Color(0xFF139d86), // U
    Color(0xFF1b75b5), // V
    Color(0xFFf4581a), // W
    Color(0xFF77c00d), // X
    Color(0xFF8e49a2), // Y
    Color(0xFFffc10d), // Z
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();
  String _selectedLetter = 'A';
  int _selectedIndex = 0;

  Future<void> _playSound(String letter) async {
    final lowercase = letter.toLowerCase();
    try {
      await _audioPlayer.play(AssetSource('audio/$lowercase.mp3'));
    } catch (e) {
      print('Error playing sound for $letter: $e');
    }
  }

  List<double> _saturationMatrix(double saturation) {
    final double invSat = 1 - saturation;
    final double r = 0.213 * invSat;
    final double g = 0.715 * invSat;
    final double b = 0.072 * invSat;

    return <double>[
      r + saturation,
      g,
      b,
      0,
      0,
      r,
      g + saturation,
      b,
      0,
      0,
      r,
      g,
      b + saturation,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.matrix(_saturationMatrix(1.5)),
              child: Image.asset(
                'assets/images/alphabet_bg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isSmallScreen = constraints.maxWidth < 400;
                final imageSize = isSmallScreen ? 40.0 : 60.0;
                final fontSize = isSmallScreen ? 30.0 : 30.0;

                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          'assets/images/back_button.png',
                          width: isSmallScreen ? 60 : 80,
                          height: isSmallScreen ? 60 : 80,
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Top "A" + "Tracing" Cards
                      SizedBox(
                        height: 150,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildMainCard(
                                _selectedLetter,
                                'assets/images/alphabets/${_selectedLetter.toLowerCase()}.png',
                                fontSize * 3.2,
                                imageSize * 3.5,
                                layout: Axis.horizontal,
                                cardColor: _kidColors[_selectedIndex],
                              ),
                            ),

                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: _buildMainCard(
                                "Tracing",
                                "assets/images/pencil.png",
                                fontSize,
                                imageSize,
                                scaleImage: true,
                                layout: Axis.vertical,
                                cardColor: _kidColors[_selectedIndex],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 20,
                          children: List.generate(26, (index) {
                            String letter = String.fromCharCode(65 + index);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedLetter = letter;
                                  _selectedIndex = index;
                                });
                                _playSound(letter);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _kidColors[index],
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(
                                        0,
                                        10,
                                      ), // 👈 only vertical shadow (bottom)
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Transform.scale(
                                    scale: 1.5,
                                    child: Text(
                                      letter,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard(
    String title,
    String imagePath,
    double fontSize,
    double imageSize, {
    bool scaleImage = false,
    Axis layout = Axis.vertical,
    Color? cardColor,
  }) {
    final imageWidget = Flexible(
      child: scaleImage
          ? Transform.scale(
              scale: 2,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image_not_supported,
                    size: imageSize,
                    color: Colors.white,
                  );
                },
              ),
            )
          : Image.asset(
              imagePath,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image_not_supported,
                  size: 29,
                  color: Colors.white,
                );
              },
            ),
    );

    final textWidget = Flexible(
      child: Text(
        title,
        style: GoogleFonts.baloo2(
          color: const Color(0xfffffcc9),
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(2, 6), // shadow towards bottom-right
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Card(
        color: layout == Axis.horizontal ? cardColor : const Color(0xff18a68b),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0, // disable default elevation
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: layout == Axis.horizontal
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      imageWidget,
                      const SizedBox(width: 16),
                      textWidget,
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      imageWidget,
                      const SizedBox(height: 12),
                      textWidget,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
