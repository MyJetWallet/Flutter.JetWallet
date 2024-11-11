import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';


class InvalidReferralCode extends StatelessWidget {
  const InvalidReferralCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Assets.svg.small.info.simpleSvg(
          height: 20,
          width: 20,
          color: sKit.colors.red,
        ),
        const SpaceW10(),
        Text(
          intl.invalidReferralCode_invalidReferralCode,
          style: STStyles.body2Medium.copyWith(
            color: sKit.colors.red,
          ),
        ),
      ],
    );
  }
}
