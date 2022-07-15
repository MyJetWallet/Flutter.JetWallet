import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class NoReferralCode extends StatelessWidget {
  const NoReferralCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SInfoPressedIcon(
          color: getIt.get<SimpleKit>().colors.blue,
        ),
        const SpaceW12(),
        Text(
          intl.noReferralCode_havePromoCode,
          style: sCaptionTextStyle.copyWith(
            color: getIt.get<SimpleKit>().colors.blue,
          ),
        ),
      ],
    );
  }
}
