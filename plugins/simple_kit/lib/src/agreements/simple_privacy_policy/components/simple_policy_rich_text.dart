import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../simple_kit.dart';

class SimplePolicyRichText extends StatelessWidget {
  const SimplePolicyRichText({
    Key? key,
    required this.firstText,
    required this.userAgreementText,
    required this.onUserAgreementTap,
    required this.betweenText,
    required this.privacyPolicyText,
    required this.onPrivacyPolicyTap,
  }) : super(key: key);

  final String firstText;
  final String userAgreementText;
  final Function() onUserAgreementTap;
  final String betweenText;
  final String privacyPolicyText;
  final Function() onPrivacyPolicyTap;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: firstText,
        style: TextStyle(
          fontSize: 12.sp,
          fontFamily: 'Gilroy',
          color: SColorsLight().black,
          fontWeight: FontWeight.w500,
        ),
        children: [
          _textSpanWithRecognizer(
            text: userAgreementText,
            onTap: onUserAgreementTap,
          ),
          TextSpan(
            text: betweenText,
          ),
          _textSpanWithRecognizer(
            text: privacyPolicyText,
            onTap: onPrivacyPolicyTap,
          ),
          const TextSpan(
            text: '.',
          ),
        ],
      ),
    );
  }
}

TextSpan _textSpanWithRecognizer({
  required String text,
  required Function() onTap,
}) {
  return TextSpan(
    text: text,
    recognizer: TapGestureRecognizer()..onTap = onTap,
    style: TextStyle(
      color: SColorsLight().blue,
    ),
  );
}
