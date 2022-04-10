import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class ValidReferralCode extends StatelessWidget {
  const ValidReferralCode({
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
            'Your referral code - $referralCode',
            style: sCaptionTextStyle,
          )
        else
          Text(
            'Valid referral code',
            style: sCaptionTextStyle,
          )
      ],
    );
  }
}
