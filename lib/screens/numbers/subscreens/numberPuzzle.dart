import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ModernNumberPuzzleScreen extends StatefulWidget {
  const ModernNumberPuzzleScreen({super.key});

  @override
  State<ModernNumberPuzzleScreen> createState() =>
      _ModernNumberPuzzleScreenState();
}

class _ModernNumberPuzzleScreenState extends State<ModernNumberPuzzleScreen>
    with TickerProviderStateMixin {
  bool isLevelOne = true;

  int gridSize = 3;
  late List<int?> tiles;
  int moves = 0;
  int stars = 0;

  int? activeHintIndex;
  Timer? hintTimer;

  @override
  void initState() {
    super.initState();
    generatePuzzle();
  }

  void generatePuzzle() {
    gridSize = 3;

    final count = gridSize * gridSize;
    tiles = List.generate(count, (i) => i == count - 1 ? null : i + 1);
    tiles.shuffle();

    moves = 0;
    activeHintIndex = null;
    setState(() {});
  }

  bool isSolved() {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i + 1) return false;
    }
    return true;
  }

  void moveTile(int index) {
    final emptyIndex = tiles.indexOf(null);

    final row = index ~/ gridSize;
    final col = index % gridSize;
    final emptyRow = emptyIndex ~/ gridSize;
    final emptyCol = emptyIndex % gridSize;

    final isAdjacent =
        (row == emptyRow && (col - emptyCol).abs() == 1) ||
        (col == emptyCol && (row - emptyRow).abs() == 1);

    if (!isAdjacent) return;

    setState(() {
      final temp = tiles[index];
      tiles[index] = null;
      tiles[emptyIndex] = temp;
      moves++;
    });

    if (isSolved()) {
      stars++;
      _showWinDialog();
    }
  }

  void showHint() {
    if (activeHintIndex != null) return;

    final empty = tiles.indexOf(null);
    final possible = <int>[];

    final row = empty ~/ gridSize;
    final col = empty % gridSize;

    if (row > 0) possible.add(empty - gridSize);
    if (row < gridSize - 1) possible.add(empty + gridSize);
    if (col > 0) possible.add(empty - 1);
    if (col < gridSize - 1) possible.add(empty + 1);

    activeHintIndex = possible[Random().nextInt(possible.length)];

    hintTimer?.cancel();
    hintTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => activeHintIndex = null);
    });

    setState(() {});
  }

  @override
  void dispose() {
    hintTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double boardSize = MediaQuery.of(context).size.width * 0.85;
    final double tileSize = boardSize / gridSize - 8;

    return Scaffold(
      backgroundColor: const Color(0xFFFFBB2D),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            /// Back Button
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Image.asset(
                  'assets/images/back_button.png',
                  width: 60,
                  height: 60,
                ),
              ),
            ),

            /// Top Stats
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statCard("Moves", "$moves"),
                  _statCard("Level", "1"),
                  _statCard("Stars", "$stars"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ✅ Aligned Grid using GridView
            Container(
              width: boardSize,
              height: boardSize,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF020617),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(color: Colors.black38, blurRadius: 30),
                ],
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: tiles.length,
                itemBuilder: (context, index) {
                  final tile = tiles[index];
                  final isHint = index == activeHintIndex;

                  if (tile == null) {
                    return const SizedBox.shrink();
                  }

                  return GestureDetector(
                    onTap: () => moveTile(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isHint
                              ? [Colors.yellow, Colors.orangeAccent]
                              : [Colors.blue, Colors.deepPurpleAccent],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isHint
                                ? Colors.yellow.withOpacity(0.9)
                                : Colors.blue.withOpacity(0.7),
                            blurRadius: isHint ? 25 : 12,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "$tile",
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // ✅ High contrast
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.white,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// Buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _gameButton("Hint", Colors.orange, showHint),
                  _gameButton("Shuffle", Colors.pink, generatePuzzle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black, // ✅ Better contrast
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black87, // ✅ Better contrast
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _gameButton(String text, Color color, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black, // ✅ Better contrast
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFF020617),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "🌟 Puzzle Solved!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Moves: $moves",
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              onPressed: () {
                Navigator.pop(context);
                generatePuzzle();
              },
              child: const Text("Play Again"),
            ),
          ],
        ),
      ),
    );
  }
}
