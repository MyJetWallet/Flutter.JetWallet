import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/modules/icons/24x24/public/complete/simple_complete_solid_icon.dart';
import 'package:simple_kit/simple_kit.dart';

class ValidReferralCodeOutSide extends StatelessWidget {
  const ValidReferralCodeOutSide({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SCompleteSolidIcon(),
          const SpaceW12(),
          Text(
            intl.validReferralCode_validReferralCode,
            style: sButtonTextStyle,
          ),
        ],
      ),
    );
  }
}
