import 'package:flutter/material.dart';
import '../../../simple_kit.dart';

class SimpleConditionsReferralInvite extends StatelessWidget {
  const SimpleConditionsReferralInvite({
    super.key,
    this.crossAxisAlignment,
    required this.conditionText,
  });

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
