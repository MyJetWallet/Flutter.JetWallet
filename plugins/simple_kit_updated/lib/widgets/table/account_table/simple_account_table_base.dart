import 'package:flutter/material.dart';

class SAccountTableBase extends StatelessWidget {
  const SAccountTableBase({
    super.key,
    this.hasButton = false,
    required this.child,
  });

  final bool hasButton;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: hasButton ? 128 : 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: child,
      ),
    );
  }
}
