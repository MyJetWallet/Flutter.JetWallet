import 'package:flutter/material.dart';
import 'package:simple_kit/modules/agreements/simple_privacy_policy/simple_policy_rich_text.dart';
import 'package:simple_kit/modules/icons/24x24/public/checkbox/simple_checkbox_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/checkbox/simple_checkbox_selected_icon.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const SpaceH24(),
            SafeGesture(
              onTap: onCheckboxTap,
              child: icon,
            ),
          ],
        ),
        const SpaceW10(),
        Flexible(
          child: Column(
            children: [
              const SpaceH23(),
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
              const SpaceH24(),
            ],
          ),
        ),
      ],
    );
  }
}
