import 'package:flutter/material.dart';
import 'package:simple_kit/modules/agreements/simple_privacy_policy/simple_policy_rich_text.dart';

import '../../../simple_kit.dart';

class SPolicyCheckbox extends StatelessWidget {
  const SPolicyCheckbox({
    Key? key,
    required this.firstText,
    required this.userAgreementText,
    required this.betweenText,
    required this.privacyPolicyText,
    required this.isChecked,
    required this.onCheckboxTap,
    required this.onUserAgreementTap,
    required this.onPrivacyPolicyTap,
    this.isSendGlobal,
    this.height,
    this.secondText,
    this.activeText,
    this.onActiveTextTap,
    this.thirdText,
    this.activeText2,
    this.firstAdditionalText,
    this.onActiveText2Tap,
  }) : super(key: key);

  final String firstText;
  final String userAgreementText;
  final String betweenText;
  final String privacyPolicyText;
  final bool isChecked;
  final Function() onCheckboxTap;
  final Function() onUserAgreementTap;
  final Function() onPrivacyPolicyTap;

  final String? secondText;
  final String? activeText;
  final Function()? onActiveTextTap;
  final String? thirdText;
  final String? activeText2;
  final String? firstAdditionalText;
  final Function()? onActiveText2Tap;
  final bool? isSendGlobal;

  final double? height;

  @override
  Widget build(BuildContext context) {
    late Widget icon;

    icon = isChecked ? const SCheckboxSelectedIcon() : const SCheckboxIcon();

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const SpaceH21(),
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
                const SpaceH22(),
                SimplePolicyRichText(
                  isSendGlobal: isSendGlobal,
                  firstText: firstText,
                  userAgreementText: userAgreementText,
                  onUserAgreementTap: onUserAgreementTap,
                  betweenText: betweenText,
                  privacyPolicyText: privacyPolicyText,
                  onPrivacyPolicyTap: onPrivacyPolicyTap,
                  secondText: secondText,
                  activeText: activeText,
                  onActiveTextTap: onActiveTextTap,
                  thirdText: thirdText,
                  activeText2: activeText2,
                  onActiveText2Tap: onActiveText2Tap,
                  firstAdditionalText: firstAdditionalText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SPolicy extends StatelessWidget {
  const SPolicy({
    super.key,
    required this.isChecked,
    required this.onCheckboxTap,
    required this.child,
  });

  final bool isChecked;
  final Function() onCheckboxTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    late Widget icon;

    icon = isChecked ? const SCheckboxSelectedIcon() : const SCheckboxIcon();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const SpaceH21(),
            SIconButton(
              onTap: onCheckboxTap,
              defaultIcon: icon,
              pressedIcon: icon,
            ),
          ],
        ),
        const SpaceW10(),
        Expanded(
          child: child,
        ),
      ],
    );
  }
}
