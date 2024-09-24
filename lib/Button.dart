import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({super.key, this.child, this.function});

  final child;
  final VoidCallback? function;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
          child:
          Container(
              child: child,
          ),
      ),

    );
  }
}
