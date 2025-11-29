import 'dart:async';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hand_landmarker/hand_landmarker.dart';

class FingerCountingPage extends StatefulWidget {
  const FingerCountingPage({super.key});

  @override
  State<FingerCountingPage> createState() => _FingerCountingPageState();
}

class _FingerCountingPageState extends State<FingerCountingPage> {
  CameraController? _controller;
  HandLandmarkerPlugin? _plugin;

  List<Hand> _landmarks = [];
  bool _isInitialized = false;
  bool _isDetecting = false;

  List<CameraDescription> _cameras = [];

  @override
  void initState() {
    super.initState();
    _initFingerCounting();
  }

  Future<void> _initFingerCounting() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    _cameras = await availableCameras();

    final camera = _cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => _cameras.first,
    );

    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    _plugin = HandLandmarkerPlugin.create(
      numHands: 2,
      minHandDetectionConfidence: 0.7,
      delegate: HandLandmarkerDelegate.CPU,
    );

    await _controller!.initialize();
    await _controller!.startImageStream(_processCameraImage);

    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  @override
  void dispose() {
    _controller?.stopImageStream();
    _controller?.dispose();
    _plugin?.dispose();
    super.dispose();
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isDetecting || !_isInitialized || _plugin == null) return;

    _isDetecting = true;

    try {
      final hands = _plugin!.detect(
        image,
        _controller!.description.sensorOrientation,
      );

      if (mounted) {
        setState(() => _landmarks = hands);
      }
    } catch (e) {
      debugPrint("Error detecting hand: $e");
    } finally {
      _isDetecting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final controller = _controller!;
    final previewSize = controller.value.previewSize!;
    final previewAspectRatio = previewSize.height / previewSize.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Finger Counting (AI ML)"),
        backgroundColor: Colors.black87,
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: previewAspectRatio,
          child: Stack(
            children: [
              CameraPreview(controller),

              /// Draw landmarks
              CustomPaint(
                size: Size.infinite,
                painter: LandmarkPainter(
                  hands: _landmarks,
                  previewSize: previewSize,
                  lensDirection: controller.description.lensDirection,
                  sensorOrientation: controller.description.sensorOrientation,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Painter to draw hand landmarks
class LandmarkPainter extends CustomPainter {
  LandmarkPainter({
    required this.hands,
    required this.previewSize,
    required this.lensDirection,
    required this.sensorOrientation,
  });

  final List<Hand> hands;
  final Size previewSize;
  final CameraLensDirection lensDirection;
  final int sensorOrientation;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / previewSize.height;

    final pointPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 8 / scale
      ..strokeCap = StrokeCap.round;

    final linePaint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 4 / scale;

    canvas.save();

    final center = Offset(size.width / 2, size.height / 2);
    canvas.translate(center.dx, center.dy);
    canvas.rotate(sensorOrientation * math.pi / 180);

    if (lensDirection == CameraLensDirection.front) {
      canvas.scale(-1, 1);
      canvas.rotate(math.pi);
    }

    canvas.scale(scale);

    final logicalWidth = previewSize.width;
    final logicalHeight = previewSize.height;

    for (final hand in hands) {
      for (final lm in hand.landmarks) {
        final dx = (lm.x - 0.5) * logicalWidth;
        final dy = (lm.y - 0.5) * logicalHeight;
        canvas.drawCircle(Offset(dx, dy), 8 / scale, pointPaint);
      }

      for (final link in HandLandmarkConnections.connections) {
        final start = hand.landmarks[link[0]];
        final end = hand.landmarks[link[1]];

        final sx = (start.x - 0.5) * logicalWidth;
        final sy = (start.y - 0.5) * logicalHeight;
        final ex = (end.x - 0.5) * logicalWidth;
        final ey = (end.y - 0.5) * logicalHeight;

        canvas.drawLine(Offset(sx, sy), Offset(ex, ey), linePaint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Connections between hand landmarks
class HandLandmarkConnections {
  static const List<List<int>> connections = [
    [0, 1], [1, 2], [2, 3], [3, 4],
    [0, 5], [5, 6], [6, 7], [7, 8],
    [5, 9], [9, 10], [10, 11], [11, 12],
    [9, 13], [13, 14], [14, 15], [15, 16],
    [13, 17], [0, 17], [17, 18], [18, 19], [19, 20],
  ];
}
