import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';
import 'components/simple_policy_rich_text.dart';

class SPolicyText extends StatelessWidget {
  const SPolicyText({
    Key? key,
    required this.firstText,
    required this.userAgreementText,
    required this.betweenText,
    required this.privacyPolicyText,
    required this.onUserAgreementTap,
    required this.onPrivacyPolicyTap,
  }) : super(key: key);

  final String firstText;
  final String userAgreementText;
  final String betweenText;
  final String privacyPolicyText;
  final Function() onUserAgreementTap;
  final Function() onPrivacyPolicyTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62.h,
      child: Column(
        children: [
          const SpaceH12(),
          SimplePolicyRichText(
            firstText: firstText,
            userAgreementText: userAgreementText,
            onUserAgreementTap: onUserAgreementTap,
            betweenText: betweenText,
            privacyPolicyText: privacyPolicyText,
            onPrivacyPolicyTap: onPrivacyPolicyTap,
          ),
        ],
      ),
    );
  }
}
