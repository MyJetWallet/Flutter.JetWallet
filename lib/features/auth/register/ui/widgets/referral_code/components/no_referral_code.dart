import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/gen/assets.gen.dart';
import 'package:flutter_ui_kit/helpers/icons_extension.dart';
import 'package:flutter_ui_kit/widgets/button/context/simple_button_context.dart';
import 'package:flutter_ui_kit/widgets/colors/simple_colors_light.dart';
import 'package:flutter_ui_kit/widgets/table/actioned/simpe_actioned.dart';
import 'package:jetwallet/core/l10n/i10n.dart';

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
      icon: Assets.svg.medium.referral.simpleSvg(),
      type: SActionedType.inverted,
    );
  }
}
