import 'package:flutter/material.dart';
import 'utils/design_palette.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Morning Buddies',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Morning Buddies'),
        ),
        body: const Column(
          children: [
            ColorBox(color: ColorStyles.primary, text: Text('Primary Box')),
            ColorBox(color: ColorStyles.secondary, text: Text('Secondary Box')),
            ColorBox(color: ColorStyles.tertiary, text: Text('Tertiary Box')),
            ColorBox(
                color: ColorStyles.quaternary, text: Text('Quaternary Box')),
          ],
        ),
      ),
    );
  }
}

class ColorBox extends StatelessWidget {
  final Color color;

  final Text text;

  const ColorBox({required this.color, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      color: color,
      child: Center(child: text),
    );
  }
}
