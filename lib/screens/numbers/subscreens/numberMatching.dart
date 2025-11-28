import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class NumberMatchingScreen extends StatefulWidget {
  const NumberMatchingScreen({super.key});

  @override
  State<NumberMatchingScreen> createState() => _NumberMatchingScreenState();
}

class _NumberMatchingScreenState extends State<NumberMatchingScreen>
    with SingleTickerProviderStateMixin {
  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 2),
  );

  final List<int> numbers = List.generate(9, (i) => i + 1);
  late List<int> shuffledNumbers;

  final Map<int, bool> matched = {};

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  int stars = 0;
  bool showSuccess = false;

  @override
  void initState() {
    super.initState();
    _setupGame();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _bounceAnimation = CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    );
  }

  void _setupGame() {
    shuffledNumbers = List.from(numbers)..shuffle(Random());
    matched.clear();
    for (var n in numbers) {
      matched[n] = false;
    }
    stars = 0;
    showSuccess = false;
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _handleMatch(int number) {
    if (matched[number] == true) return;

    setState(() {
      matched[number] = true;
      stars++;
    });

    _confettiController.play();
    _bounceController.forward(from: 0);

    if (stars == numbers.length) {
      setState(() => showSuccess = true);
    }
  }

  void _resetGame() {
    setState(() => _setupGame());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFffbb2d),
      body: Stack(
        children: [
          /// MAIN GAME
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER ROW
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          'assets/images/back_button.png',
                          width: 70,
                          height: 70,
                        ),
                      ),
                      Spacer(),

                      /// Star counter on the right
                      ScaleTransition(
                        scale: _bounceAnimation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 32,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "$stars",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// TARGET GRID
                  Expanded(
                    child: GridView.count(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: numbers.map((number) {
                        return DragTarget<int>(
                          onWillAccept: (data) => data == number,
                          onAccept: (data) => _handleMatch(number),
                          builder: (context, candidateData, rejectedData) {
                            final isMatched = matched[number] ?? false;
                            final isHighlighted = candidateData.isNotEmpty;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isMatched
                                    ? Colors.green.shade400
                                    : (isHighlighted
                                          ? Colors.orange.shade100
                                          : Colors.white),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.deepOrange,
                                  width: 3,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(2, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                isMatched ? "✅ $number" : "$number",
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Drag & Drop",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  /// DRAGGABLE AREA
                  Container(
                    height: size.height * 0.22,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: GridView.count(
                      crossAxisCount: 5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: shuffledNumbers.map((number) {
                        if (matched[number] == true) {
                          return const SizedBox();
                        }
                        return Draggable<int>(
                          data: number,

                          /// BIGGER while dragging
                          feedback: Transform.scale(
                            scale: 1.5,
                            child: _buildNumberCard(number, true),
                          ),

                          childWhenDragging: _buildNumberCard(
                            number,
                            false,
                            faded: true,
                          ),
                          child: _buildNumberCard(number, false),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 🎉 CONFETTI — ABOVE EVERYTHING
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  emissionFrequency: 0.15,
                  numberOfParticles: 120,
                  gravity: 0.15,
                  minBlastForce: 60,
                  maxBlastForce: 150,
                  shouldLoop: false,
                ),
              ),
            ),
          ),

          /// 🎉 SUCCESS OVERLAY
          if (showSuccess)
            Container(
              color: Colors.black54,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "🎉 Level Complete!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "You earned $stars ⭐",
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _resetGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Play Again",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNumberCard(int number, bool dragging, {bool faded = false}) {
    return Opacity(
      opacity: faded ? 0.4 : 1,
      child: Material(
        color: Colors.transparent,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: dragging ? Colors.orangeAccent : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.deepOrange, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(2, 3),
              ),
            ],
          ),
          child: Text(
            "$number",
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
