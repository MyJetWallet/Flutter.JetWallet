import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class InvalidReferralCode extends StatelessWidget {
  const InvalidReferralCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SCrossIcon(),
        const SpaceW10(),
        Text(
          intl.invalidReferralCodeLink_invalidReferralCodeLink,
          style: sCaptionTextStyle,
        ),
      ],
    );
  }
}
