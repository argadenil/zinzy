import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class HumanBodyScreen extends StatefulWidget {
  const HumanBodyScreen({super.key});

  @override
  State<HumanBodyScreen> createState() => _HumanBodyScreenState();
}

class _HumanBodyScreenState extends State<HumanBodyScreen> {
  late Flutter3DController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Flutter3DController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFBB2D),
      body: SafeArea(
        child: Column(
          children: [
            /// 🔙 BACK BUTTON
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    "assets/images/back_button.webp",
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
            ),

            const Text(
              "Human Body & Health",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),

            const SizedBox(height: 12),

            /// 📘 CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🧍 3D HUMAN BODY
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xff3c2815),
                          width: 4,
                        ),
                      ),
                      child: Flutter3DViewer(
                        controller: _controller,
                        src: "assets/science/human_body.glb",
                        progressBarColor: Colors.orange,
                        enableTouch: true,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🧠 BODY PARTS INFO
                    _infoTitle("Main Parts of the Human Body"),
                    _infoText(
                      "Our body has many parts that work together to keep us alive and healthy.",
                    ),

                    _bullet("Brain", "Controls thinking, memory, and actions"),
                    _bullet("Heart", "Pumps blood to all body parts"),
                    _bullet("Lungs", "Help us breathe"),
                    _bullet("Stomach", "Digests food"),
                    _bullet("Bones", "Give shape and support"),
                    _bullet("Muscles", "Help us move"),

                    const SizedBox(height: 16),

                    /// 🍎 DIGESTIVE SYSTEM
                    _infoTitle("Digestive System"),
                    _infoText(
                      "The digestive system helps us break down food and absorb nutrients.",
                    ),

                    _bullet("Mouth", "Chews food and mixes it with saliva"),
                    _bullet("Food Pipe", "Carries food to the stomach"),
                    _bullet("Stomach", "Breaks food into simpler forms"),
                    _bullet("Small Intestine", "Absorbs nutrients into blood"),
                    _bullet(
                      "Large Intestine",
                      "Absorbs water and removes waste",
                    ),

                    const SizedBox(height: 16),

                    /// 🧼 HEALTH TIPS
                    _infoTitle("Healthy Habits"),
                    _bullet("Eat healthy food", "Fruits, vegetables, milk"),
                    _bullet("Drink clean water", "Keeps body hydrated"),
                    _bullet("Exercise daily", "Keeps body strong"),
                    _bullet("Brush teeth twice", "Prevents tooth decay"),
                    _bullet("Wash hands", "Prevents diseases"),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

  static Widget _infoTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      ),
    );
  }

  static Widget _infoText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }

  static Widget _bullet(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "•  ",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
