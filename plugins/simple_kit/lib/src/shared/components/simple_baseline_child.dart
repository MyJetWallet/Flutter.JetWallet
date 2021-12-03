import 'package:flutter/material.dart';

class SBaselineChild extends StatelessWidget {
  const SBaselineChild({
    Key? key,
    required this.baseline,
    required this.child,
  }) : super(key: key);

  final double baseline;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: baseline,
      child: Baseline(
        baseline: baseline,
        baselineType: TextBaseline.alphabetic,
        child: child,
      ),
    );
  }
}
