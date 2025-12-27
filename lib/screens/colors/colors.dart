import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ColorsScreen extends StatefulWidget {
  const ColorsScreen({super.key});

  @override
  State<ColorsScreen> createState() => _ColorsScreenState();
}

class _ColorsScreenState extends State<ColorsScreen> {
  CameraController? _controller;
  bool _isDetecting = false;

  Color detectedColor = Colors.grey;
  String colorName = "Point camera at a color";

  final Map<String, Color> knownColors = {
    "Red": Colors.red,
    "Green": Colors.green,
    "Blue": Colors.blue,
    "Yellow": Colors.yellow,
    "Orange": Colors.orange,
    "Purple": Colors.purple,
    "Black": Colors.black,
    "White": Colors.white,
  };

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    await Permission.camera.request();

    final cameras = await availableCameras();
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.low,
      enableAudio: false,
    );

    await _controller!.initialize();
    _controller!.startImageStream(_processImage);

    setState(() {});
  }

  void _processImage(CameraImage image) {
    if (_isDetecting) return;
    _isDetecting = true;

    final plane = image.planes.first;
    final bytes = plane.bytes;

    int r = 0, g = 0, b = 0;
    int count = 0;

    // sample center pixels
    for (int i = bytes.length ~/ 2;
        i < bytes.length ~/ 2 + 500;
        i += 4) {
      r += bytes[i];
      g += bytes[i + 1];
      b += bytes[i + 2];
      count++;
    }

    r ~/= count;
    g ~/= count;
    b ~/= count;

    final Color avgColor = Color.fromARGB(255, r, g, b);
    final String nearest = _findNearestColor(avgColor);

    setState(() {
      detectedColor = knownColors[nearest]!;
      colorName = nearest;
    });

    _isDetecting = false;
  }

  String _findNearestColor(Color input) {
    double minDistance = double.infinity;
    String closest = "Unknown";

    for (var entry in knownColors.entries) {
      final c = entry.value;
      final distance = sqrt(
        pow(input.red - c.red, 2) +
            pow(input.green - c.green, 2) +
            pow(input.blue - c.blue, 2),
      );

      if (distance < minDistance) {
        minDistance = distance;
        closest = entry.key;
      }
    }

    return closest;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("📷 Find the Color"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          CameraPreview(_controller!),

          /// Center guide box
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          /// Result panel
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: detectedColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                  )
                ],
              ),
              child: Text(
                "This looks $colorName",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color:
                      detectedColor == Colors.yellow ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
