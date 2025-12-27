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
  int _lastCount = 0;
  String _lastHandLabel = ''; // optional

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

    // Create plugin — defensive defaults
    _plugin = HandLandmarkerPlugin.create(
      numHands: 2,
      minHandDetectionConfidence: 0.6,
      delegate: HandLandmarkerDelegate.cpu,
    );

    await _controller!.initialize();

    // start stream
    await _controller!.startImageStream(_processCameraImage);

    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  @override
  void dispose() {
    try {
      _controller?.stopImageStream();
    } catch (_) {}
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
        setState(() {
          _landmarks = hands;
        });

        // If at least one hand, compute count and update
        if (hands.isNotEmpty) {
          final first = hands.first;
          final count = _countFingers(first, _controller!.description.lensDirection);
          setState(() {
            _lastCount = count;
          });
        } else {
          setState(() {
            _lastCount = 0;
          });
        }
      }
    } catch (e) {
      debugPrint("Error detecting hand: $e");
    } finally {
      _isDetecting = false;
    }
  }

  /// Count fingers for a single detected hand.
  /// Uses tip vs pip (y) for four fingers and a horizontal test for thumb.
  int _countFingers(Hand hand, CameraLensDirection lensDirection) {
    // hand.landmarks expected to be a list of points with .x and .y normalized [0..1]
    if (hand.landmarks.isEmpty || hand.landmarks.length < 21) return 0;

    // safe access
    final lm = hand.landmarks;

    bool validIndex(int i) => i >= 0 && i < lm.length;

    // indices for tips and pip (MediaPipe order)
    final tips = {
      'thumb': 4,
      'index': 8,
      'middle': 12,
      'ring': 16,
      'pinky': 20,
    };
    final pips = {
      'thumb_ip': 3, // thumb ip joint
      'index': 6,
      'middle': 10,
      'ring': 14,
      'pinky': 18,
    };

    int count = 0;

    // Helper to check numeric validity
    bool okPoint(int idx) {
      if (!validIndex(idx)) return false;
      final p = lm[idx];
      if (p == null) return false;
      final x = p.x, y = p.y;
      return x != null && y != null && x.isFinite && y.isFinite && !x.isNaN && !y.isNaN;
    }

    // For index/middle/ring/pinky: tip.y < pip.y means finger is up (y increases downward).
    for (final finger in ['index', 'middle', 'ring', 'pinky']) {
      final tipIdx = tips[finger]!;
      final pipIdx = pips[finger]!;
      if (okPoint(tipIdx) && okPoint(pipIdx)) {
        final tip = lm[tipIdx];
        final pip = lm[pipIdx];
        if (tip.y < pip.y) count++;
      }
    }

    // Thumb logic:
    // Determine hand orientation (rough): compare x of wrist(0) and index mcp(5) or pinky base.
    // If wrist.x < indexBase.x => hand faces one way. We'll use direction to decide > or < tests.
    int thumbUp = 0;
    if (okPoint(tips['thumb']!) && okPoint(pips['thumb_ip']!)) {
      final tip = lm[tips['thumb']!];
      final ip = lm[pips['thumb_ip']!];
      // orientation reference: index base (5) and pinky base (17)
      if (okPoint(5) && okPoint(17)) {
        final indexBase = lm[5];
        final pinkyBase = lm[17];
        // if pinkyBase.x < indexBase.x, the hand is likely "right" (depending on camera)
        final handDirection = pinkyBase.x - indexBase.x;
        // If handDirection > 0 => pinky is to the right of index -> that implies one orientation.
        // For thumb, check horizontal relation between tip and ip, adjusting for orientation and front camera mirror.
        // If tip is farther from palm in the expected direction, it's extended.
        // Use lensDirection to handle front camera mirroring: front camera sometimes mirrors input,
        // but landmark coordinates are usually in image coordinates (not mirrored) — this heuristic is robust enough.
        if (handDirection > 0) {
          // pinky to right of index => thumb extends to left (lower x)
          if (tip.x < ip.x - 0.02) thumbUp = 1;
        } else {
          // other orientation => thumb extends to right (higher x)
          if (tip.x > ip.x + 0.02) thumbUp = 1;
        }
      } else {
        // fallback: compare tip.x relative to ip.x
        if ((tip.x - ip.x).abs() > 0.03 && tip.x < ip.x) {
          // heuristic: if tip left of ip significantly -> treat as up
          thumbUp = 1;
        } else if ((tip.x - ip.x).abs() > 0.03 && tip.x > ip.x) {
          thumbUp = 1;
        }
      }
    }

    count += thumbUp;
    return count;
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Finger Counting (AI ML)"),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: AspectRatio(
            aspectRatio: previewAspectRatio,
            child: Stack(
              children: [
                CameraPreview(controller),

                /// Neon landmarks overlay
                CustomPaint(
                  size: Size.infinite,
                  painter: NeonLandmarkPainter(
                    hands: _landmarks,
                    previewSize: previewSize,
                    lensDirection: controller.description.lensDirection,
                    sensorOrientation: controller.description.sensorOrientation,
                  ),
                ),

                // Count display — neon card top-left
                Positioned(
                  left: 16,
                  top: 16,
                  child: _NeonCountBadge(count: _lastCount),
                ),

                // Large center count with glow
                Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: _lastCount > 0 ? 1.0 : 0.6,
                    child: _BigGlowNumber(count: _lastCount),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small neon badge showing count
class _NeonCountBadge extends StatelessWidget {
  final int count;
  const _NeonCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.18),
            blurRadius: 18,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.fingerprint, color: Colors.cyanAccent),
          const SizedBox(width: 8),
          Text(
            "$count",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

/// Big glowing number in center
class _BigGlowNumber extends StatelessWidget {
  final int count;
  const _BigGlowNumber({required this.count});

  @override
  Widget build(BuildContext context) {
    final text = count > 0 ? "$count" : "-";
    return Stack(
      alignment: Alignment.center,
      children: [
        // outer glow layers
        for (var i = 0; i < 5; i++)
          Text(
            text,
            style: TextStyle(
              fontSize: 120 + i * 10,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent.withOpacity(0.06 + i * 0.04),
              shadows: [
                Shadow(
                  blurRadius: 30.0 + i * 10,
                  color: Colors.cyanAccent.withOpacity(0.06 + i * 0.04),
                ),
              ],
            ),
          ),
        // main text
        Text(
          text,
          style: const TextStyle(
            fontSize: 120,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

/// Neon painter (safe)
class NeonLandmarkPainter extends CustomPainter {
  NeonLandmarkPainter({
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
    try {
      // scale to map normalized landmarks (0..1) to preview logical size
      final scale = size.width / previewSize.height;
      // paints (base)
      final basePointPaint = Paint()
        ..color = Colors.cyanAccent
        ..style = PaintingStyle.fill;

      final baseLinePaint = Paint()
        ..color = Colors.cyanAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4 / scale
        ..strokeCap = StrokeCap.round;

      // We'll draw neon by drawing multiple strokes with increasing width and decreasing opacity.
      canvas.save();

      final center = Offset(size.width / 2, size.height / 2);
      canvas.translate(center.dx, center.dy);
      canvas.rotate(sensorOrientation * math.pi / 180);

      if (lensDirection == CameraLensDirection.front) {
        // Mirror so overlay matches camera preview
        canvas.scale(-1, 1);
        canvas.rotate(math.pi);
      }

      canvas.scale(scale);

      final logicalWidth = previewSize.width;
      final logicalHeight = previewSize.height;

      for (final hand in hands) {
        if (hand.landmarks.isEmpty || hand.landmarks.length < 21) continue;

        // neon connections (glow)
        for (final link in HandLandmarkConnections.connections) {
          final a = link[0];
          final b = link[1];

          if (a >= hand.landmarks.length || b >= hand.landmarks.length) continue;

          final start = hand.landmarks[a];
          final end = hand.landmarks[b];
          if (!_valid(start.x) || !_valid(start.y) || !_valid(end.x) || !_valid(end.y)) continue;

          final sx = (start.x - 0.5) * logicalWidth;
          final sy = (start.y - 0.5) * logicalHeight;
          final ex = (end.x - 0.5) * logicalWidth;
          final ey = (end.y - 0.5) * logicalHeight;

          // glow: multiple strokes
          for (int i = 4; i >= 0; i--) {
            final opacity = (0.08 * (i + 1)).clamp(0.02, 0.5);
            final stroke = baseLinePaint..color = Colors.cyanAccent.withOpacity(opacity);
            stroke.strokeWidth = (2.0 + i * 2.6) / scale;
            canvas.drawLine(Offset(sx, sy), Offset(ex, ey), stroke);
          }
        }

        // neon points
        for (final lm in hand.landmarks) {
          if (!_valid(lm.x) || !_valid(lm.y)) continue;
          final dx = (lm.x - 0.5) * logicalWidth;
          final dy = (lm.y - 0.5) * logicalHeight;

          // glow rings
          for (int i = 6; i >= 1; i--) {
            final opacity = (0.04 * i).clamp(0.02, 0.5);
            final r = (6.0 + i * 2.8) / scale;
            final p = Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = (1.0 + i * 1.2) / scale
              ..color = Colors.cyanAccent.withOpacity(opacity);
            canvas.drawCircle(Offset(dx, dy), r, p);
          }

          // center dot
          canvas.drawCircle(Offset(dx, dy), 4 / scale, basePointPaint);
        }
      }

      canvas.restore();
    } catch (e) {
      debugPrint("NeonLandmarkPainter error: $e");
    }
  }

  bool _valid(double v) {
    return v != null && v.isFinite && !v.isNaN;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Simple connections list (same mapping as MediaPipe)
class HandLandmarkConnections {
  static const List<List<int>> connections = [
    [0, 1], [1, 2], [2, 3], [3, 4],
    [0, 5], [5, 6], [6, 7], [7, 8],
    [5, 9], [9, 10], [10, 11], [11, 12],
    [9, 13], [13, 14], [14, 15], [15, 16],
    [13, 17], [0, 17], [17, 18], [18, 19], [19, 20],
  ];
}
