import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class LoadingReferralCode extends StatelessWidget {
  const LoadingReferralCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16.0,
          height: 16.0,
          child: CircularProgressIndicator(
            color: sKit.colors.grey1,
            strokeWidth: 2.0,
          ),
        ),
        const SpaceW12(),
        Text(
          intl.checkingReferralCode_checking,
          style: sBodyText2Style.copyWith(
            color: sKit.colors.grey1,
          ),
        ),
      ],
    );
  }
}
