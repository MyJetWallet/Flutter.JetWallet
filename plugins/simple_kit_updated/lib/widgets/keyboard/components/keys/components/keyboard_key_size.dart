import 'package:flutter/material.dart';

class KeyboardKeySize extends StatelessWidget {
  const KeyboardKeySize({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 59.0,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
