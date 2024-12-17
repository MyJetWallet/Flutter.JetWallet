import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

class ValidReferralCodeInside extends StatelessWidget {
  const ValidReferralCodeInside({
    super.key,
    this.referralCode,
  });

  final String? referralCode;

  @override
  Widget build(BuildContext context) {
    final showReferral = referralCode?.replaceFirst('https://join.simple.app/', '');

    return Row(
      children: [
        Assets.svg.small.check.simpleSvg(
          width: 20,
          color: SColorsLight().blue,
        ),
        const SpaceW12(),
        if (referralCode != null)
          Text(
            '${intl.validReferralCode_yourReferralCode} - $showReferral',
            style: STStyles.body2Medium.copyWith(
              color: SColorsLight().blue,
            ),
          )
        else
          Text(
            intl.validReferralCode_validReferralCode,
            style: STStyles.body2Medium.copyWith(
              color: SColorsLight().blue,
            ),
          ),
      ],
    );
  }
}
