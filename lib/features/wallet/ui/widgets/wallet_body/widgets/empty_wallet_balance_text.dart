import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class EmptyWalletBalanceText extends StatelessWidget {
  const EmptyWalletBalanceText({
    Key? key,
    required this.height,
    required this.baseline,
    required this.color,
  }) : super(key: key);

  final Color color;
  final double height;
  final double baseline;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Baseline(
        baseline: baseline,
        baselineType: TextBaseline.alphabetic,
        child: Text(
          '\$0',
          style: sTextH0Style.copyWith(
            color: color,
          ),
        ),
      ),
    );
  }
}
