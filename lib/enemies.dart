import 'package:flutter/material.dart';

class Enemies extends StatelessWidget {
  const Enemies({super.key, required this.collision});

  final bool collision;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      child: collision
          ? Image.asset('images/enemy_3.png')
          : Image.asset('images/enemy_5.png'),
    );
  }
}
