import 'package:flutter/material.dart';

class Astronaut extends StatelessWidget {
  const Astronaut({super.key, required this.midrun});

  final bool midrun;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      child: midrun
      ? Image.asset('images/astronaut_facing_left.png'):
      Image.asset('images/astronaut_facing_right.png'),
    );
  }
}
