import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import 'components/simple_disclaimer_rich_text.dart';

class SDisclaimerCheckbox extends StatelessWidget {
  const SDisclaimerCheckbox({
    Key? key,
    required this.firstText,
    required this.isChecked,
    required this.onCheckboxTap,
    required this.onUserAgreementTap,
    required this.onPrivacyPolicyTap,
  }) : super(key: key);

  final String firstText;
  final bool isChecked;
  final Function() onCheckboxTap;
  final Function() onUserAgreementTap;
  final Function() onPrivacyPolicyTap;

  @override
  Widget build(BuildContext context) {
    late Widget icon;

    if (isChecked) {
      icon = const SCheckboxSelectedIcon();
    } else {
      icon = const SCheckboxIcon();
    }

    return SizedBox(
      height: 44.0,
      child: Row(
        children: [
          Column(
            children: [
              //const SpaceH20(),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceH6(),
                SimpleDisclaimerRichText(
                  firstText: firstText,
                  onUserAgreementTap: onUserAgreementTap,
                  onPrivacyPolicyTap: onPrivacyPolicyTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
