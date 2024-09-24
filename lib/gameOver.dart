import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {
  const GameOver({super.key, required this.gameOver});

  final bool gameOver;

  @override
  Widget build(BuildContext context) {
    return gameOver ? Container(
      alignment: Alignment(0, 0),
      child: ElevatedButton(
          onPressed: () {
              Navigator.of(context).pop();
      },
          child: Text('GAME OVER!', style: TextStyle(color: Colors.white, fontFamily: 'Silkscreen-Regular', fontSize: 80),),
      ),

    ): Container();
  }
}

