import 'package:flutter/material.dart';

class Alphabet extends StatefulWidget {
  const Alphabet({super.key});

  @override
  State<Alphabet> createState() => _AlphabetState();
}

class _AlphabetState extends State<Alphabet> {
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
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/images/back_button.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.arrow_back,
                        size: 32,
                        color: Colors.black,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Center(
              child: Text(
                "Alphabets Content",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff475873),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
