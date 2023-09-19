import 'package:flutter/material.dart';
import 'package:simple_kit/modules/agreements/simple_privacy_policy/simple_policy_rich_text.dart';
import 'package:simple_kit/modules/buttons/simple_icon_button.dart';
import 'package:simple_kit/modules/icons/24x24/public/checkbox/simple_checkbox_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/checkbox/simple_checkbox_selected_icon.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';

import '../../../core/l10n/i10n.dart';

class GiftPolicyCheckbox extends StatelessWidget {
  const GiftPolicyCheckbox({
    super.key,
    required this.isChecked,
    required this.onCheckboxTap,
  });
  final bool isChecked;
  final Function() onCheckboxTap;

  @override
  Widget build(BuildContext context) {
    late Widget icon;

    icon = isChecked ? const SCheckboxSelectedIcon() : const SCheckboxIcon();

    return SizedBox(
      height: 156,
      child: Row(
        children: [
          Column(
            children: [
              const SpaceH24(),
              SIconButton(
                onTap: onCheckboxTap,
                defaultIcon: icon,
                pressedIcon: icon,
              ),
            ],
          ),
          const SpaceW10(),
          Expanded(
            child: Column(
              children: [
                const SpaceH25(),
                SimplePolicyRichText(
                  firstText: intl.send_gift_policy,
                  userAgreementText: '',
                  onUserAgreementTap: () {},
                  betweenText: '',
                  privacyPolicyText: '',
                  onPrivacyPolicyTap: () {},
                  secondText: '',
                  activeText: '',
                  onActiveTextTap: () {},
                  thirdText: '',
                  activeText2: '',
                  onActiveText2Tap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
