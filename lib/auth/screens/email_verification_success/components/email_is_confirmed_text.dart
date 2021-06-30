import 'package:flutter/material.dart';

class EmailIsConfirmedText extends StatelessWidget {
  const EmailIsConfirmedText({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Your email address $email is confirmed',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
