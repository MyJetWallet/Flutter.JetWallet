import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
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
        Text(
          referralCode != null
              ? '${intl.validReferralCode_yourReferralCode} - $referralCode'
              : intl.validReferralCode_validReferralCode,
          style: sCaptionTextStyle,
        ),
      ],
    );
  }
}
