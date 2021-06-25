import 'package:flutter/material.dart';

class SuccessText extends StatelessWidget {
  const SuccessText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Success',
      style: TextStyle(
        fontSize: 45.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
