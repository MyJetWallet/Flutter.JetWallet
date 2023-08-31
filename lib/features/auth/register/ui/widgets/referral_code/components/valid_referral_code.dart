import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

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
        const STickSelectedIcon(),
        const SpaceW10(),
        if (referralCode != null)
          Text(
            '${intl.validReferralCode_yourReferralCode} - $showReferral',
            style: sCaptionTextStyle,
          )
        else
          Text(
            intl.validReferralCode_validReferralCode,
            style: sCaptionTextStyle,
          ),
      ],
    );
  }
}
