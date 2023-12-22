import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/widgets/button/context/simple_button_context.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/table/actioned/simpe_actioned.dart';

class NoReferralCode extends StatelessWidget {
  const NoReferralCode({
    super.key,
    required this.onAddPressed,
  });

  final void Function() onAddPressed;

  @override
  Widget build(BuildContext context) {
    return SActioned(
      label: intl.referralCode_have_a_referral_code,
      button: SButtonContext(
        text: intl.referralCode_add,
        onTap: onAddPressed,
        type: SButtonContextType.basic,
        backgroundColor: SColorsLight().white,
      ),
      icon: Padding(
        padding: const EdgeInsets.only(top: 7),
        child: Assets.svg.medium.referral.simpleSvg(),
      ),
      type: SActionedType.inverted,
    );
  }
}
