import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_practice/screen_one.dart';

void main() {
  runApp(const Starbound());
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
}
class Starbound extends StatelessWidget {
  const Starbound({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StarboundApp(),
    );
  }
}

