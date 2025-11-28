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

    final isAdjacent = (row == emptyRow && (col - emptyCol).abs() == 1) ||
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

    activeHintIndex = possible[_randomIndex(possible.length)];

    hintTimer?.cancel();
    hintTimer = Timer(const Duration(seconds: 2), () {
      setState(() => activeHintIndex = null);
    });

    setState(() {});
  }

  void nextLevel() {
    if (gridSize < 5) gridSize++;
    generatePuzzle();
  }

  int _randomIndex(int max) => Random().nextInt(max);

  @override
  void dispose() {
    hintTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tileSize = MediaQuery.of(context).size.width / (gridSize + 1);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("🧠 Smart Number Puzzle"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // Top Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _statCard("Moves", "$moves"),
              _statCard("Level", "${gridSize - 2}"),
              _statCard("Stars", "$stars"),
            ],
          ),

          const SizedBox(height: 20),

          // Puzzle board
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF020617),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, blurRadius: 30)
                  ],
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(tiles.length, (index) {
                    final tile = tiles[index];
                    final isHint = index == activeHintIndex;

                    if (tile == null) {
                      return SizedBox(
                        width: tileSize,
                        height: tileSize,
                      );
                    }

                    return GestureDetector(
                      onTap: () => moveTile(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: tileSize,
                        height: tileSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: isHint
                                ? [Colors.yellow, Colors.orange]
                                : [
                                    Colors.blueAccent,
                                    Colors.deepPurple,
                                  ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isHint
                                  ? Colors.yellow.withOpacity(0.8)
                                  : Colors.blue.withOpacity(0.6),
                              blurRadius: isHint ? 25 : 12,
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "$tile",
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Controls
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _gameButton("Hint", Colors.orange, showHint),
                _gameButton("Shuffle", Colors.pink, generatePuzzle),
                _gameButton("Next Level", Colors.green, nextLevel),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: const Color(0xFF020617),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("🌟 Level Complete!",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 16),
            Text("Moves: $moves",
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              onPressed: () {
                Navigator.pop(context);
                nextLevel();
              },
              child: const Text("Next Level"),
            )
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(title,
            style: TextStyle(color: Colors.white.withOpacity(0.7))),
      ],
    );
  }

  Widget _gameButton(String text, Color color, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      onPressed: onTap,
      child: Text(text,
          style: const TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}
