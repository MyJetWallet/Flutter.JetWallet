import 'package:flutter/material.dart';
import '../../../simple_kit.dart';

class SimpleConditionsReferralInvite extends StatelessWidget {
  const SimpleConditionsReferralInvite({
    Key? key,
    this.crossAxisAlignment,
    required this.conditionText,
  }) : super(key: key);

  final String conditionText;
  final CrossAxisAlignment? crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return SPaddingH24(
      child: Row(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        children: [
          const SCompleteIcon(),
          const SpaceW20(),
          Baseline(
            baseline: 16,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              conditionText,
              maxLines: 2,
              style: sBodyText1Style,
            ),
          ),
        ],
      ),
    );
  }
}
