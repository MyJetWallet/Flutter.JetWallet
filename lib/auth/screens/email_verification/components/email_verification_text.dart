import 'package:flutter/material.dart';

class EmailVerificationText extends StatelessWidget {
  const EmailVerificationText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18.0,
      ),
    );
  }
}
