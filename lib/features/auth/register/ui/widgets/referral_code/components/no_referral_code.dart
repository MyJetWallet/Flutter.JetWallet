import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class NoReferralCode extends StatelessWidget {
  const NoReferralCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SInfoPressedIcon(
          color: sKit.colors.blue,
        ),
        const SpaceW12(),
        Text(
          intl.user_data_no_referral_code,
          style: sCaptionTextStyle.copyWith(
            color: sKit.colors.blue,
          ),
        ),
      ],
    );
  }
}
