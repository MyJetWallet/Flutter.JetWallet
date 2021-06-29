import 'package:flutter/material.dart';

class ResendInText extends StatelessWidget {
  const ResendInText({
    Key? key,
    required this.seconds,
  }) : super(key: key);

  final int seconds;

  @override
  Widget build(BuildContext context) {
    return Text(
      'You can resend in $seconds seconds',
      style: const TextStyle(
        color: Colors.grey,
      ),
    );
  }
}
