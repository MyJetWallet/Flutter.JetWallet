import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

class InvalidReferralCode extends StatelessWidget {
  const InvalidReferralCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SCrossIcon(),
        const SpaceW10(),
        Text(
          'Invalid referral code/link',
          style: sCaptionTextStyle,
        ),
      ],
    );
  }
}
