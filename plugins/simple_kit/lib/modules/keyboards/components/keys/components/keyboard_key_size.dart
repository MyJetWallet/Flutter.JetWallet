import 'package:flutter/material.dart';

class KeyboardKeySize extends StatelessWidget {
  const KeyboardKeySize({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 56.0,
        child: child,
      ),
    );
  }
}
