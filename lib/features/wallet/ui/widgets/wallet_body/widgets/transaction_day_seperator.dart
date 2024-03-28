import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class TransactionDaySeparator extends StatelessObserverWidget {
  const TransactionDaySeparator({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return SizedBox(
      height: 21,
      child: Baseline(
        baseline: 11,
        baselineType: TextBaseline.alphabetic,
        child: Row(
          children: [
            Text(
              text,
              style: STStyles.body2Semibold.copyWith(
                color: colors.grey3,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Divider(
                color: colors.grey3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
