import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

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
        icon: Assets.svg.medium.delete.simpleSvg(
          color: colors.red,
        ),
        type: SButtonContextType.iconedSmallInverted,
        backgroundColor: SColorsLight().white,
      ),
      icon: Assets.svg.medium.referral.simpleSvg(),
      type: SActionedType.inverted,
    );
  }
}
