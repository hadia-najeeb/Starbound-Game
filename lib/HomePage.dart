import 'package:flutter/material.dart';
import 'package:project_practice/enemies.dart';
import 'package:project_practice/jumpingAstronaut.dart';
import 'dart:async';
import 'Button.dart';
import 'character.dart';
import 'gameOver.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static double AstronautX = -0.75;
  static double AstronautY = 1;
  double time = 0;
  double height = 0;
  double initialHeight = AstronautY;
  bool midrun = false;
  bool midjump = false;
  late bool gameOver;
  static double enemyXone = 0;
  static double enemyXtwo = 1.09;
  static double enemyXthree = 2;
  Timer? movementTimer;

  int score = 0;

  @override
  void initState() {
    super.initState();
    gameOver = false;
    startMovement();
  }

  double moveEnemy(double enemyX) {
    if (enemyX < -1.1) {
      return 1.5; // Reset position to the right
    } else {
      return enemyX - 0.03; // Move left
    }
  }

  void startMovement() {
    movementTimer = Timer.periodic(Duration(milliseconds: 60), (timer) {
      if (gameOver) {
        timer.cancel(); // Stop the movement when the game is over
      } else {
        setState(() {
          // Move enemies continuously to the left
          enemyXone = moveEnemy(enemyXone);
          enemyXtwo = moveEnemy(enemyXtwo);
          enemyXthree = moveEnemy(enemyXthree);

          print("Enemy positions: $enemyXone, $enemyXtwo, $enemyXthree");

          if (checkCollision()) {
            gameOver = true;
            timer.cancel();
            showGameOverPopup();
          }
        });
      }
    });
  }

  // Function to display a Game Over popup
  void showGameOverPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('GAME OVER!', style: TextStyle(fontFamily: 'Silkscreen-Regular', fontSize: 40),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close popup
                resetGame(); // Restart the game
              },
              child: Text('RESTART', style: TextStyle(fontFamily: 'Silkscreen-Regular', fontSize: 20),),
            ),
          ],
        );
      },
    );
  }

  // Reset the game after game over
  void resetGame() {
    setState(() {
      AstronautX = -0.75;
      AstronautY = 1;
      enemyXone = 0;
      enemyXtwo = 1.09;
      enemyXthree = 2;
      gameOver = false;
      midrun = false;
      midjump = false;
      score = 0; // Reset the score
      startMovement();
    });
  }

  // Collision detection function
  bool checkCollision() {
    double astronautWidth = 0.2;
    double astronautHeight = 0.2;
    double enemyWidth = 0.2;
    double enemyHeight = 0.2;

    bool collidesWithEnemyOne = (enemyXone - astronautWidth < AstronautX &&
        enemyXone + enemyWidth > AstronautX) &&
        (1 - enemyHeight < AstronautY && 1 + enemyHeight > AstronautY);

    bool collidesWithEnemyTwo = (enemyXtwo - astronautWidth < AstronautX &&
        enemyXtwo + enemyWidth > AstronautX) &&
        (1 - enemyHeight < AstronautY && 1 + enemyHeight > AstronautY);

    bool collidesWithEnemyThree = (enemyXthree - astronautWidth < AstronautX &&
        enemyXthree + enemyWidth > AstronautX) &&
        (-0.3 - enemyHeight < AstronautY && -0.3 + enemyHeight > AstronautY);

    return collidesWithEnemyOne || collidesWithEnemyTwo || collidesWithEnemyThree;
  }

  void preJump() {
    time = 0;
    initialHeight = AstronautY;
  }

  void jump() {
    if (!midjump) {
      midjump = true;
      preJump();
      setState(() {
        midrun = true;
      });
      Timer.periodic(Duration(milliseconds: 60), (timer) {
        time += 0.05;
        height = -4.9 * time * time + 5 * time;

        if (initialHeight - height > 1) {
          midjump = false;
          setState(() {
            AstronautY = 1;
            midrun = false;
            score += 1; // Increment score after a successful jump
          });
          timer.cancel();
        } else {
          setState(() {
            AstronautY = initialHeight - height;
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
    return Scaffold(
      body: GestureDetector(
        onTap: jump, // Detect tap to trigger jump
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Container(
                    color: Colors.black,
                    child: AnimatedContainer(
                      alignment: Alignment(AstronautX, AstronautY),
                      duration: Duration(milliseconds: 0),
                      child: midjump
                          ? Jumpingastronaut()
                          : Astronaut(midrun: midrun),
                    ),
                  ),
                  Container(
                    alignment: Alignment(enemyXone, 1),
                    child: Enemies(collision: true),
                  ),
                  Container(
                    alignment: Alignment(enemyXtwo, 1),
                    child: Enemies(collision: false),
                  ),
                  Container(
                    alignment: Alignment(enemyXthree, -0.3),
                    child: Enemies(collision: true),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Score: $score', // Display current score
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Silkscreen-Regular',
                              fontSize: 40),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'HighScore: 0000', // Static HighScore for now
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Silkscreen-Regular',
                              fontSize: 40),
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
                // The bottom container is empty since the button was removed
              ),
            ),
          ],
        ),
      ),
    );
  }
}