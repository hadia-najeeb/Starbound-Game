import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const StarboundApp());
}

class StarboundApp extends StatelessWidget {
  const StarboundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Starbound',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Starry animated background
          Positioned.fill(
            child: AnimatedBackground(animation: _animation),
          ),
          // Content over the background
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Handle start button press
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    textStyle: const TextStyle(fontSize: 24),
                  ),
                  child: const Text('Start'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle recent results button press
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    textStyle: const TextStyle(fontSize: 24),
                  ),
                  child: const Text('Recent Results'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle leaderboard button press
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    textStyle: const TextStyle(fontSize: 24),
                  ),
                  child: const Text('Leaderboard'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedBackground extends StatelessWidget {
  final Animation<double> animation;

  const AnimatedBackground({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          painter: SpaceBackgroundPainter(animation.value),
          child: Container(),
        );
      },
    );
  }
}

class SpaceBackgroundPainter extends CustomPainter {
  final double animationValue;
  final Random random = Random();
  final List<Offset> stars = [];

  SpaceBackgroundPainter(this.animationValue) {
    // Generate random star positions when the painter is created
    for (int i = 0; i < 100; i++) {
      stars.add(Offset(random.nextDouble(), random.nextDouble()));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the cosmic gradient background
    final Rect rect = Offset.zero & size;
    final Paint backgroundPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.black, Colors.blueGrey.shade900, Colors.indigo.shade900],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, backgroundPaint);

    // Draw planets (as circles)
    _drawPlanet(canvas, size, const Offset(0.2, 0.7), 80, Colors.redAccent.withOpacity(0.5));
    _drawPlanet(canvas, size, const Offset(0.8, 0.3), 100, Colors.blueAccent.withOpacity(0.3));

    // Draw stars
    final Paint starPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final double animationOffset = animationValue * size.height;

    for (var star in stars) {
      double starX = star.dx * size.width;  // Scale star's x based on screen width
      double starY = (star.dy * size.height) - animationOffset;  // Scale star's y based on screen height and animation

      // Wrap stars around when they move out of view
      if (starY > size.height) {
        starY -= size.height;
      }

      canvas.drawCircle(Offset(starX, starY), 2, starPaint);
    }

    // Draw shooting stars
    _drawShootingStar(canvas, size, animationValue);
  }

  void _drawPlanet(Canvas canvas, Size size, Offset position, double radius, Color color) {
    final Paint planetPaint = Paint()..color = color;
    final Offset center = Offset(position.dx * size.width, position.dy * size.height);
    canvas.drawCircle(center, radius, planetPaint);
  }

  void _drawShootingStar(Canvas canvas, Size size, double animationValue) {
    final Paint shootingStarPaint = Paint()..color = Colors.white.withOpacity(0.8);
    final double starLength = 150.0;
    final Offset startPosition = Offset(animationValue * size.width, animationValue * size.height / 2);
    final Offset endPosition = startPosition + Offset(-starLength, starLength);
    canvas.drawLine(startPosition, endPosition, shootingStarPaint..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Continually repaint to keep the animation running
  }
}