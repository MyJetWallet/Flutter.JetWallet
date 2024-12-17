import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

class InvalidReferralCode extends StatelessWidget {
  const InvalidReferralCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Assets.svg.small.info.simpleSvg(
          height: 20,
          width: 20,
          color: SColorsLight().red,
        ),
        const SpaceW10(),
        Text(
          intl.invalidReferralCode_invalidReferralCode,
          style: STStyles.body2Medium.copyWith(
            color: SColorsLight().red,
          ),
        ),
      ],
    );
  }
}
