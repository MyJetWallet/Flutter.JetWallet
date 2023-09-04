import 'package:flutter/material.dart';

class PaddingL24 extends StatelessWidget {
  const PaddingL24({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
      ),
      child: child,
    );
  }
}
