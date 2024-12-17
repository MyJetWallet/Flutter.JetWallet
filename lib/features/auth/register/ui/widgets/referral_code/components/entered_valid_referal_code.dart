import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

class EnteredValidReferalCode extends StatelessWidget {
  const EnteredValidReferalCode({
    super.key,
    required this.referralCode,
    required this.onDelete,
  });

  final String referralCode;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return SActioned(
      label: referralCode,
      supplement: intl.validReferralCode_yourReferralCode,
      button: SButtonContext(
        text: intl.validReferralCode_delete,
        onTap: onDelete,
        contentColor: colors.red,
        icon: Assets.svg.medium.delete,
        iconCustomColor: colors.red,
        type: SButtonContextType.iconedSmallInverted,
        backgroundColor: SColorsLight().white,
      ),
      icon: Assets.svg.medium.referral.simpleSvg(),
      type: SActionedType.inverted,
    );
  }
}
