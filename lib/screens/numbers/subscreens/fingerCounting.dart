import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

class FingerCountingPage extends StatefulWidget {
  const FingerCountingPage({super.key});

  @override
  State<FingerCountingPage> createState() => _FingerCountingPageState();
}

class _FingerCountingPageState extends State<FingerCountingPage> {
  CameraController? _controller;
  Interpreter? _interpreter;
  bool _busy = false;
  bool _initialized = false;

  List<Offset> points = [];
  int fingerCount = 0;

  @override
  void initState() {
    super.initState();
    initML();
  }

  Future<void> initML() async {
    // Ask permission
    final status = await Permission.camera.request();
    if (!status.isGranted) return;

    final cameras = await availableCameras();
    final frontCam = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      frontCam,
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
      enableAudio: false,
    );

    await _controller!.initialize();

    // Load TFLite model
    _interpreter = await Interpreter.fromAsset("assets/hand_landmark.tflite");

    // Start camera stream
    _controller!.startImageStream((CameraImage imgRaw) {
      if (!_busy) {
        _busy = true;
        processCameraImage(imgRaw).whenComplete(() => _busy = false);
      }
    });

    if (!mounted) return;
    setState(() => _initialized = true);
  }

  // Convert YUV420 camera image → RGB using image 4.1.4 Pixel API
  img.Image convertYUV420ToRGB(CameraImage image) {
    final width = image.width;
    final height = image.height;

    final img.Image rgb = img.Image(width: width, height: height);

    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    final yStride = yPlane.bytesPerRow;
    final uStride = uPlane.bytesPerRow;
    final vStride = vPlane.bytesPerRow;

    for (int y = 0; y < height; y++) {
      final yIndex = y * yStride;
      final uIndex = (y ~/ 2) * uStride;
      final vIndex = (y ~/ 2) * vStride;

      for (int x = 0; x < width; x++) {
        final Y = yPlane.bytes[yIndex + x] & 0xFF;
        final U = uPlane.bytes[uIndex + (x ~/ 2)] & 0xFF;
        final V = vPlane.bytes[vIndex + (x ~/ 2)] & 0xFF;

        int R = (Y + 1.370705 * (V - 128)).round().clamp(0, 255);
        int G = (Y - 0.337633 * (U - 128) - 0.698001 * (V - 128)).round().clamp(0, 255);
        int B = (Y + 1.732446 * (U - 128)).round().clamp(0, 255);

        rgb.setPixel(x, y, img.ColorFloat16.rgb(R, G, B));
      }
    }

    return rgb;
  }

  Future<void> processCameraImage(CameraImage cameraImage) async {
    if (_interpreter == null) return;

    // Convert YUV → RGB
    final img.Image rgb = convertYUV420ToRGB(cameraImage);

    // Resize to model input size 224x224
    final img.Image resized = img.copyResize(rgb, width: 224, height: 224);

    // Prepare tensor [1,224,224,3]
    final input = List.generate(
      1,
      (_) => List.generate(
        224,
        (_) => List.generate(224, (_) => List.filled(3, 0.0)),
      ),
    );

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final img.Pixel p = resized.getPixel(x, y);
        final int r = p.r.toInt();
        final int g = p.g.toInt();
        final int b = p.b.toInt();

        input[0][y][x][0] = r / 255.0;
        input[0][y][x][1] = g / 255.0;
        input[0][y][x][2] = b / 255.0;
      }
    }

    // Output shape: 63 floats (21 × 3)
    final output = List.generate(1, (_) => List.filled(63, 0.0));

    _interpreter!.run(input, output);

    // Extract 21 landmarks
    final List<Offset> pts = [];
    for (int i = 0; i < 21; i++) {
      double x = output[0][i * 3];
      double y = output[0][i * 3 + 1];
      pts.add(Offset(x, y));
    }

    final bool front = _controller!.description.lensDirection == CameraLensDirection.front;

    if (!mounted) return;

    setState(() {
      points = pts;
      fingerCount = countFingers(pts, isFront: front);
    });
  }

  int countFingers(List<Offset> lm, {required bool isFront}) {
    if (lm.length < 21) return 0;

    bool isUp(int tip, int pip) => lm[tip].dy < lm[pip].dy;

    int c = 0;
    if (isUp(8, 6)) c++;  // Index
    if (isUp(12, 10)) c++; // Middle
    if (isUp(16, 14)) c++; // Ring
    if (isUp(20, 18)) c++; // Pinky

    // Thumb — check x
    bool thumbUp = isFront ? lm[4].dx < lm[3].dx : lm[4].dx > lm[3].dx;
    if (thumbUp) c++;

    return c;
  }

  @override
  void dispose() {
    _controller?.dispose();
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("AI Finger Counting")),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          CustomPaint(
            painter: HandPainter(points),
            child: Container(),
          ),
          Positioned(
            top: 30,
            left: 20,
            child: Text(
              "Fingers: $fingerCount",
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(blurRadius: 5, color: Colors.black),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HandPainter extends CustomPainter {
  final List<Offset> pts;

  HandPainter(this.pts);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.fill;

    for (final p in pts) {
      canvas.drawCircle(
        Offset(p.dx * size.width, p.dy * size.height),
        5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant HandPainter oldDelegate) => true;
}
