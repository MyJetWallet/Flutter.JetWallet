import 'package:flutter/material.dart';
import 'package:simple_kit/modules/agreements/simple_privacy_policy/simple_policy_rich_text.dart';

class SPolicyText extends StatelessWidget {
  const SPolicyText({
    super.key,
    required this.firstText,
    required this.userAgreementText,
    required this.betweenText,
    required this.privacyPolicyText,
    required this.onUserAgreementTap,
    required this.onPrivacyPolicyTap,
  });

  final String firstText;
  final String userAgreementText;
  final String betweenText;
  final String privacyPolicyText;
  final Function() onUserAgreementTap;
  final Function() onPrivacyPolicyTap;

  @override
  Widget build(BuildContext context) {
    return SimplePolicyRichText(
      firstText: firstText,
      userAgreementText: userAgreementText,
      onUserAgreementTap: onUserAgreementTap,
      betweenText: betweenText,
      privacyPolicyText: privacyPolicyText,
      onPrivacyPolicyTap: onPrivacyPolicyTap,
    );
  }
}
