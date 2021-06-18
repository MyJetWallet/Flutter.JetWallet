import 'package:flutter/material.dart';

class WelcomeScreenText extends StatelessWidget {
  const WelcomeScreenText({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 46,
      ),
    );
  }
}
