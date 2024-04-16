import 'package:flutter/material.dart';

/// Can be used only for one-row text
class SBaselineChild extends StatelessWidget {
  const SBaselineChild({
    super.key,
    required this.baseline,
    required this.child,
  });

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
