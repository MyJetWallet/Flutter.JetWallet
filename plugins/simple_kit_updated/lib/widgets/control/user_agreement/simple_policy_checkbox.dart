import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'simple_policy_rich_text.dart';

class SPolicyCheckbox extends StatelessWidget {
  const SPolicyCheckbox({
    super.key,
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
  });

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
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(height: 21),
              SizedBox(
                width: 20,
                height: 20,
                child: CupertinoCheckbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    onCheckboxTap.call();
                  },
                  checkColor: Colors.white,
                  activeColor: Colors.black,
                  side: BorderSide(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 22),
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
