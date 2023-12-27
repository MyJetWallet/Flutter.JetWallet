import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';

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
          color: sKit.colors.blue,
        ),
        const SpaceW12(),
        if (referralCode != null)
          Text(
            '${intl.validReferralCode_yourReferralCode} - $showReferral',
            style: sBodyText2Style.copyWith(
              color: sKit.colors.blue,
            ),
          )
        else
          Text(
            intl.validReferralCode_validReferralCode,
            style: sBodyText2Style.copyWith(
              color: sKit.colors.blue,
            ),
          ),
      ],
    );
  }
}
