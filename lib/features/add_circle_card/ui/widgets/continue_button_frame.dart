import 'package:flutter/material.dart';

class ContinueButtonFrame extends StatelessWidget {
  const ContinueButtonFrame({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: child,
      ),
    );
  }
}
