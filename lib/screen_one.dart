import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_practice/HomePage.dart';
import 'package:project_practice/main.dart';

void main() {
  runApp(const StarboundApp());
}

class StarboundApp extends StatelessWidget {
  const StarboundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      duration: const Duration(seconds: 3),
      vsync: this,
    )
      ..repeat();
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: double.infinity, // Allow the text to use full width
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'STARBOUND',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 80,
                        fontFamily: 'Silkscreen-Regular',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
                      backgroundColor: Colors.black,
                      textStyle: const TextStyle(fontSize: 24, fontFamily: 'Silkscreen-Regular'),
                    ),
                    child: const Text('Start Game'),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle recent results button press
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
                      backgroundColor: Colors.black,
                      textStyle: const TextStyle(fontSize: 24, fontFamily: 'Silkscreen-Regular'),
                    ),
                    child: const Text('Recent Results'),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle leaderboard button press
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
                      backgroundColor: Colors.black,
                      textStyle: const TextStyle(fontSize: 24, fontFamily: 'Silkscreen-Regular'),
                    ),
                    child: const Text('Leaderboard'),
                  ),
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
  final List<Asteroid> asteroids = [];
  final double starSpeedfFactor = 0.01;

  SpaceBackgroundPainter(this.animationValue) {
    // Generate 100 random star positions when the painter is created
    for (int i = 0; i < 100; i++) {
      stars.add(Offset(random.nextDouble(), random.nextDouble()));
    }

    // Generate random asteroids
    for (int i = 0; i < 5; i++) {
      asteroids.add(Asteroid(
        position: Offset(random.nextDouble(), random.nextDouble()),
        speed: Offset(random.nextDouble() * 2 - 1, random.nextDouble() * 2 - 1),
        size: random.nextDouble() * 50 + 20,
      ));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw black background
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);

    // Draw stars
    final Paint starPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final double animationOffset = animationValue * size.height * starSpeedfFactor;

    for (var star in stars) {
      double starX = star.dx * size.width;  // Scale star's x based on screen width
      double starY = (star.dy * size.height);  // Scale star's y based on screen height and animation

      // Wrap stars around when they move out of view
      if (starY > size.height) {
        starY -= size.height;
      }

      canvas.drawCircle(Offset(starX, starY), 2, starPaint);
    }

    // Draw and animate asteroids
    for (var asteroid in asteroids) {
      _drawAsteroid(canvas, size, asteroid);
    }
  }

  void _drawAsteroid(Canvas canvas, Size size, Asteroid asteroid) {
    // Calculate the asteroid's new position
    final double asteroidX = (asteroid.position.dx * size.width + asteroid.speed.dx * animationValue * size.width) % size.width;
    final double asteroidY = (asteroid.position.dy * size.height + asteroid.speed.dy * animationValue * size.height) % size.height;

    final Paint asteroidPaint = Paint()..color = Colors.grey.withOpacity(0.8);
    canvas.drawCircle(Offset(asteroidX, asteroidY), asteroid.size, asteroidPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Continually repaint to keep the animation running
  }
}

class Asteroid {
  Offset position;
  Offset speed;
  double size;

  Asteroid({required this.position, required this.speed, required this.size});
}