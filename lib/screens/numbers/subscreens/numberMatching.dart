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

  static const double pagePadding = 16;
  static const double cardRadius = 22;

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
      backgroundColor: const Color(0xFFFFBB2D),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(pagePadding),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          'assets/images/back_button.png',
                          width: 60,
                          height: 60,
                        ),
                      ),
                      ScaleTransition(
                        scale: _bounceAnimation,
                        child: _buildStarCounter(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// TARGET GRID
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: numbers.length,
                      itemBuilder: (context, index) {
                        final number = numbers[index];
                        return _buildTargetCard(number);
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Center(
                    child: Text(
                      "Drag & Drop",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// DRAGGABLE GRID
                  Container(
                    height: size.height * 0.23,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: shuffledNumbers.length,
                      itemBuilder: (context, index) {
                        final number = shuffledNumbers[index];
                        if (matched[number] == true) {
                          return const SizedBox();
                        }

                        return Draggable<int>(
                          data: number,

                          /// FIXED draggable feedback (when user drags)
                          feedback: Material(
                            color: Colors.transparent,
                            child: Transform.scale(
                              scale: 1.6,
                              child: _buildDragCard(number, true),
                            ),
                          ),

                          /// While dragging – faded placeholder
                          childWhenDragging: _buildDragCard(
                            number,
                            false,
                            faded: true,
                          ),

                          /// Normal state
                          child: _buildDragCard(number, false),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// CONFETTI
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

          /// SUCCESS SCREEN
          if (showSuccess) _buildSuccessOverlay(),
        ],
      ),
    );
  }

  /// STAR COUNTER
  Widget _buildStarCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 30),
          const SizedBox(width: 6),
          Text(
            "$stars",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// TARGET CARD
  Widget _buildTargetCard(int number) {
    return DragTarget<int>(
      onWillAccept: (data) => data == number,
      onAccept: (_) => _handleMatch(number),
      builder: (context, candidate, rejected) {
        final isMatched = matched[number] ?? false;
        final isHighlighted = candidate.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isMatched
                ? Colors.green.shade400
                : (isHighlighted ? Colors.orange.shade100 : Colors.white),
            borderRadius: BorderRadius.circular(cardRadius),
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
            isMatched ? "✅ $number" : "$number",
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  /// DRAG CARD
  Widget _buildNumberCard(int number, bool dragging, {bool faded = false}) {
    return Opacity(
      opacity: faded ? 0.4 : 1,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: dragging ? Colors.orangeAccent : Colors.white,
          borderRadius: BorderRadius.circular(cardRadius),
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
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// SUCCESS OVERLAY
  Widget _buildSuccessOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 32),
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
              Text("You earned $stars ⭐", style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text("Play Again", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildDragCard(int number, bool dragging, {bool faded = false}) {
  return Opacity(
    opacity: faded ? 0.3 : 1,
    child: Container(
      width: 70,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: dragging ? Colors.orangeAccent : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.deepOrange, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            spreadRadius: 2,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        "$number",
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none, // ✅ Removes yellow underline
          color: Colors.black,
        ),
      ),
    ),
  );
}
