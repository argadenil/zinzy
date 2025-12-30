import 'package:flutter/material.dart';

class ScienceScreen extends StatelessWidget {
  const ScienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          "Class 4 Science",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.9,
          children: const [
            UnitCard(
              title: "Life Science",
              subtitle: "Plants & Animals",
              icon: "🌱🐾",
              colors: [Color(0xFF56AB2F), Color(0xFFA8E063)],
            ),
            UnitCard(
              title: "Human Body",
              subtitle: "& Health",
              icon: "🧠❤️",
              colors: [Color(0xFFFC4A1A), Color(0xFFF7B733)],
            ),
            UnitCard(
              title: "Matter",
              subtitle: "& Materials",
              icon: "🧪🧱",
              colors: [Color(0xFF36D1DC), Color(0xFF5B86E5)],
            ),
            UnitCard(
              title: "Force",
              subtitle: "Work & Energy",
              icon: "⚙️🔋",
              colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
            ),
            UnitCard(
              title: "Earth",
              subtitle: "& Universe",
              icon: "🌍☀️",
              colors: [Color(0xFF2193B0), Color(0xFF6DD5ED)],
            ),
            UnitCard(
              title: "Environment",
              subtitle: "& Safety",
              icon: "♻️🚦",
              colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
            ),
          ],
        ),
      ),
    );
  }
}

/// --------------------------------------------------
/// 🔹 UNIT CARD WIDGET
/// --------------------------------------------------
class UnitCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final List<Color> colors;

  const UnitCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to unit detail screen
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: colors.last.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 42),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
