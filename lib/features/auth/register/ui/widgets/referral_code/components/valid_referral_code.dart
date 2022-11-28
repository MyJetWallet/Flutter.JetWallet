import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class ValidReferralCodeInside extends StatelessWidget {
  const ValidReferralCodeInside({
    Key? key,
    this.referralCode,
  }) : super(key: key);

  final String? referralCode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const STickSelectedIcon(),
        const SpaceW10(),
        if (referralCode != null)
          Text(
            '${intl.validReferralCode_yourReferralCode} - $referralCode',
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
