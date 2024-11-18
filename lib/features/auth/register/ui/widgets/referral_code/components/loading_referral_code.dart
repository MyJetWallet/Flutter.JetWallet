import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

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
            color: SColorsLight().gray10,
            strokeWidth: 2.0,
          ),
        ),
        const SpaceW12(),
        Text(
          intl.checkingReferralCode_checking,
          style: STStyles.body2Medium.copyWith(
            color: SColorsLight().gray10,
          ),
        ),
      ],
    );
  }
}
