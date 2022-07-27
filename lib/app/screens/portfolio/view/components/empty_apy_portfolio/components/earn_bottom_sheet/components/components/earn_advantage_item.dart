import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class EarnAdvantageItem extends StatelessWidget {
  const EarnAdvantageItem({
    Key? key,
    this.crossAxisAlignment,
    required this.text,
  }) : super(key: key);

  final String text;
  final CrossAxisAlignment? crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: [
        const SCompleteIcon(),
        const SpaceW20(),
        Flexible(
          child: FittedBox(
            child: Baseline(
              baseline: 16,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                text,
                maxLines: 2,
                style: sBodyText1Style,
              ),
            ),
          ),
        )
      ],
    );
  }
}
