import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

class EnterdValidReferalCode extends StatelessWidget {
  const EnterdValidReferalCode({
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
      buttonLabale: intl.validReferralCode_delete,
      buttonContentCollor: colors.red,
      buttonIcon: Assets.svg.medium.delete.simpleSvg(
        color: colors.red,
      ),
      icon: Assets.svg.medium.referral.simpleSvg(),
      opPress: onDelete,
      type: SActionedType.inverted,
    );
  }
}
