import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class VerificationSteep extends StatelessWidget {
  const VerificationSteep({
    required this.itemString,
    this.isDone = false,
    this.isDisabled = false,
  });

  final String itemString;
  final bool isDone;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          if (isDisabled)
            Assets.svg.small.minusCircle.simpleSvg(
              color: colors.black,
            )
          else if (!isDone)
            Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.only(left: 2),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.black,
              ),
            )
          else
            Assets.svg.small.checkCircle.simpleSvg(
              color: colors.blue,
            ),
          const SpaceW16(),
          Text(
            itemString,
            style: STStyles.subtitle1.copyWith(
              color: isDone ? colors.blue : colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
