import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'character.dart';
import 'jumpingAstronaut.dart';
import 'enemies.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double astronautX = -0.75;
  static double astronautY = 1;
  double time = 0;
  double height = 0;
  double initialHeight = astronautY;
  bool midRun = false;
  bool midJump = false;
  late bool gameOver;
  late List<Enemy> enemies;
  Timer? movementTimer;
  int score = 0;
  int highScore = 0;

  @override
  void initState() {
    super.initState();
    gameOver = false;
    _initializeEnemies();
    startMovement();
  }

  void _initializeEnemies() {
    // Adjusted to place enemies at different y positions for better gameplay dynamics.
    enemies = [
      Enemy(xPos: 1.0, yPos: 1, speed: 0.03, collision: true),  // Ground level
      Enemy(xPos: 1.8, yPos: 0.3, speed: 0.04, collision: false), // Mid-air
      Enemy(xPos: 2.5, yPos: -0.5, speed: 0.05, collision: true), // Higher jump required
    ];
  }

  // Adjust enemy speed based on score
  double getEnemySpeed(double baseSpeed) {
    return baseSpeed + (score / 50); // Speed increases as score grows
  }

  void startMovement() {
    movementTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (gameOver) {
        timer.cancel();
      } else {
        setState(() {
          for (var enemy in enemies) {
            enemy.xPos = moveEnemy(enemy.xPos, getEnemySpeed(enemy.speed));
          }

          if (checkCollision()) {
            gameOver = true;
            timer.cancel();
            showGameOverPopup();
          }
        });
      }
    });
  }

  double moveEnemy(double enemyX, double speed) {
    if (enemyX < -1.2) {
      return 1.5; // Reset position to the right
    } else {
      return enemyX - speed; // Move left by speed value
    }
  }

  void showGameOverPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('GAME OVER!',
              style: TextStyle(fontFamily: 'Silkscreen-Regular', fontSize: 40)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Text('RESTART',
                  style: TextStyle(fontFamily: 'Silkscreen-Regular', fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      astronautX = -0.75;
      astronautY = 1;
      _initializeEnemies();
      gameOver = false;
      midRun = false;
      midJump = false;
      if (score > highScore) {
        highScore = score;
      }
      score = 0;
      startMovement();
    });
  }

  bool checkCollision() {
    double astronautWidth = 0.2;
    double astronautHeight = 0.4;

    for (var enemy in enemies) {
      if ((enemy.xPos - astronautWidth < astronautX &&
              enemy.xPos + 0.2 > astronautX) &&
          (enemy.yPos - astronautHeight < astronautY &&
              enemy.yPos + 0.2 > astronautY)) {
        return true;
      }
    }
    return false;
  }

  void preJump() {
    time = 0;
    initialHeight = astronautY;
  }

  void jump() {
    if (!midJump) {
      midJump = true;
      preJump();
      setState(() {
        midRun = true;
      });
      Timer.periodic(const Duration(milliseconds: 60), (timer) {
        time += 0.05;
        height = -4.9 * time * time + 5 * time;

        if (initialHeight - height > 1) {
          midJump = false;
          setState(() {
            astronautY = 1;
            midRun = false;
            score += 1; // Increment score after a successful jump
          });
          timer.cancel();
        } else {
          setState(() {
            astronautY = initialHeight - height;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    movementTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        onTap: jump,
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.black,
                      child: AnimatedContainer(
                        alignment: Alignment(astronautX, astronautY),
                        duration: const Duration(milliseconds: 0),
                        child: midJump
                            ? Jumpingastronaut()
                            : Astronaut(midrun: midRun),
                      ),
                    ),
                    ...enemies.map((enemy) => Container(
                          alignment: Alignment(enemy.xPos, enemy.yPos),
                          child: Enemies(collision: enemy.collision),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Score: $score',
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Silkscreen-Regular',
                                fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'HighScore: $highScore',
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Silkscreen-Regular',
                                fontSize: 20),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.blueGrey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Enemy {
  double xPos;
  double yPos;
  double speed;
  bool collision;

  Enemy({required this.xPos, required this.yPos, required this.speed, required this.collision});
}
