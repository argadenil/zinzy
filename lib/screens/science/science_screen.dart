import 'package:flutter/material.dart';

class ScienceScreen extends StatelessWidget {
  const ScienceScreen({super.key});

  static final List<ScienceUnit> _units = [
    ScienceUnit(
      title: "Life Science",
      subtitle: "Plants & Animals",
      icon: "🌱🐾",
      colors: AppGradients.ocean,
    ),
    ScienceUnit(
      title: "Human Body",
      subtitle: "& Health",
      icon: "🧠❤️",
      colors: AppGradients.sunset,
    ),
    ScienceUnit(
      title: "Matter",
      subtitle: "& Materials",
      icon: "🧪🧱",
      colors: AppGradients.leaf,
    ),
    ScienceUnit(
      title: "Force",
      subtitle: "Work & Energy",
      icon: "⚙️🔋",
      colors: AppGradients.fire,
    ),
    ScienceUnit(
      title: "Earth",
      subtitle: "& Universe",
      icon: "🌍☀️",
      colors: AppGradients.space,
    ),
    ScienceUnit(
      title: "Environment",
      subtitle: "& Safety",
      icon: "♻️🚦",
      colors: AppGradients.sky,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

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

            /// 🧪 GRID
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _units.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 3 : 2,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  return UnitCard(unit: _units[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// 🎨 GRADIENT PALETTE
////////////////////////////////////////////////////////
class AppGradients {
  static const sky = [Color(0xff0d5ea6), Color(0xff3d9aab)];
  static const sunset = [Color(0xffFF7043), Color(0xfffa6f15)];
  static const leaf = [Color(0xff0ead69), Color(0xff9fb020)];
  static const fire = [Color(0xffc32501), Color(0xfffda503)];
  static const space = [Color(0xff7F00FF), Color(0xffBA68C8)];
  static const ocean = [Color(0xff36D1DC), Color(0xff3d9aab)];
}

////////////////////////////////////////////////////////
/// 🧩 UNIT CARD (NO ANIMATION)
////////////////////////////////////////////////////////
class UnitCard extends StatelessWidget {
  final ScienceUnit unit;

  const UnitCard({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          // TODO: Navigate to subtopic screen
        },
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: unit.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xff3c2815), width: 6),
            boxShadow: [
              BoxShadow(
                color: unit.colors.last.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(unit.icon, style: const TextStyle(fontSize: 46)),
                const SizedBox(height: 16),
                Text(
                  unit.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  unit.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// 📦 DATA MODEL
////////////////////////////////////////////////////////
class ScienceUnit {
  final String title;
  final String subtitle;
  final String icon;
  final List<Color> colors;

  const ScienceUnit({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
  });
}
