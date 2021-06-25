import 'package:flutter/material.dart';

class EmailIsConfirmedText extends StatelessWidget {
  const EmailIsConfirmedText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Your email address danilkin2ua@gmail.com is confirmed',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
