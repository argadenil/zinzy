import 'dart:math';
import 'package:flutter/material.dart';

class CountObjectsScreen extends StatefulWidget {
  const CountObjectsScreen({super.key});

  @override
  State<CountObjectsScreen> createState() => _CountObjectsScreenState();
}

class _CountObjectsScreenState extends State<CountObjectsScreen>
    with TickerProviderStateMixin {
  final Random _random = Random();
  int _objectCount = 0;
  bool _showSuccess = false;
  bool _showWrong = false;

  final List<String> _objectImages = [
    'assets/images/alphabets/a.png',
    'assets/images/alphabets/f.png',
    'assets/images/alphabets/g.png',
    'assets/images/alphabets/h.png',
    'assets/images/alphabets/i.png',
    'assets/images/alphabets/k.png',
    'assets/images/alphabets/pencil.png',
    'assets/images/alphabets/m.png',
    'assets/images/alphabets/t.png',
    'assets/images/alphabets/v.png',
  ];

  String _currentObject = "";
  List<Offset> _positions = [];

  @override
  void initState() {
    super.initState();
    _generateObjects();
  }

  void _generateObjects() {
    setState(() {
      _showSuccess = false;
      _showWrong = false;

      _objectCount = _random.nextInt(9) + 1; // 1–9 objects
      _currentObject = _objectImages[_random.nextInt(_objectImages.length)];

      _positions.clear();
      for (int i = 0; i < _objectCount; i++) {
        _positions.add(
          Offset(_random.nextDouble() * 0.8, _random.nextDouble() * 0.6),
        );
      }
    });
  }

  void _checkAnswer(int selected) {
    if (selected == _objectCount) {
      setState(() {
        _showSuccess = true;
        _showWrong = false;
      });

      Future.delayed(const Duration(seconds: 2), _generateObjects);
    } else {
      setState(() {
        _showWrong = true;
        _showSuccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfffbf0),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// Header
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Count the Objects',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Objects Display Area
            Expanded(
              flex: 6,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.brown, width: 4),
                ),
                child: Stack(
                  children: List.generate(_objectCount, (index) {
                    return Positioned(
                      left:
                          MediaQuery.of(context).size.width *
                          _positions[index].dx,
                      top:
                          MediaQuery.of(context).size.height *
                          0.45 *
                          _positions[index].dy,
                      child: Image.asset(_currentObject, width: 60, height: 60),
                    );
                  }),
                ),
              ),
            ),

            /// Success / Wrong Message
            if (_showSuccess)
              const Text(
                "✅ Correct!",
                style: TextStyle(fontSize: 30, color: Colors.green),
              ),
            if (_showWrong)
              const Text(
                "❌ Try Again!",
                style: TextStyle(fontSize: 28, color: Colors.red),
              ),

            const SizedBox(height: 10),

            /// Number Buttons
            Expanded(
              flex: 3,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final number = index + 1;
                  return GestureDetector(
                    onTap: () => _checkAnswer(number),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade300,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.brown, width: 3),
                      ),
                      child: Text(
                        "$number",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
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
    );
  }
}
