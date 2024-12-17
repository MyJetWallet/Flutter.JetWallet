import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

class TransactionDaySeparator extends StatelessObserverWidget {
  const TransactionDaySeparator({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

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
                color: colors.gray6,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Divider(
                color: colors.gray6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
