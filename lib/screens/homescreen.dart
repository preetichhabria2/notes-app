import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showConfetti = true;

  final List<Color> colors = [
    const Color(0xFF8EC5FC),
    const Color(0xFFE0C3FC),
    const Color(0xFFFED6E3),
    const Color(0xFF96EFFF),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    // Show confetti longer (6 seconds)
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          _showConfetti = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getColor(double value) {
    int index = (value * (colors.length - 1)).floor();
    int nextIndex = (index + 1) % colors.length;
    double t = (value * (colors.length - 1)) % 1.0;
    return Color.lerp(colors[index], colors[nextIndex], t)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '✨ Notes Hub',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final color = _getColor(_controller.value);
          final nextColor = _getColor((_controller.value + 0.1) % 1.0);

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, nextColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Floating bubbles
                ...List.generate(12, (index) {
                  final random = Random(index);
                  final size = random.nextDouble() * 20 + 20;
                  final top =
                      random.nextDouble() * MediaQuery.of(context).size.height;
                  final left =
                      random.nextDouble() * MediaQuery.of(context).size.width;
                  return Positioned(
                    top: top,
                    left: left,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  );
                }),

                // 🎉 Lottie Confetti Animation (6s)
                if (_showConfetti)
                  Center(
                    child: Lottie.asset(
                      'assets/animations/Animation - 1744363906144.json',
                      repeat: false,
                      width: 300,
                    ),
                  ),

                // Foreground content
                child!,
              ],
            ),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🎉 Welcome to Notes App!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black26,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                '📝 Note down your ideas, thoughts,\n and random sparks of genius!',
                style: TextStyle(fontSize: 18, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // Add Note Button
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/add'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                    // ignore: deprecated_member_use
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.note_add_rounded, color: Colors.white),
                      SizedBox(width: 12),
                      Text(
                        'Add New Note ✍️',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),
              const Text(
                '💡 "Creativity is intelligence having fun."',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
