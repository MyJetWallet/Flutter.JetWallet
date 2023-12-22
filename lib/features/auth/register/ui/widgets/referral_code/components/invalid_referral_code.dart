import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';

class InvalidReferralCode extends StatelessWidget {
  const InvalidReferralCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.83,
          child: Assets.svg.small.info.simpleSvg(
            color: sKit.colors.red,
          ),
        ),
        const SpaceW10(),
        Text(
          intl.invalidReferralCode_invalidReferralCode,
          style: sBodyText2Style.copyWith(
            color: sKit.colors.red,
          ),
        ),
      ],
    );
  }
}
