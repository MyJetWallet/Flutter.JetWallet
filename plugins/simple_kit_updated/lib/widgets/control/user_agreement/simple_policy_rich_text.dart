import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SimplePolicyRichText extends StatelessWidget {
  const SimplePolicyRichText({
    super.key,
    required this.firstText,
    required this.userAgreementText,
    required this.onUserAgreementTap,
    required this.betweenText,
    required this.privacyPolicyText,
    required this.onPrivacyPolicyTap,
    this.isSendGlobal,
    this.secondText,
    this.activeText,
    this.onActiveTextTap,
    this.thirdText,
    this.firstAdditionalText,
    this.activeText2,
    this.onActiveText2Tap,
  });

  final String firstText;
  final String userAgreementText;
  final Function() onUserAgreementTap;
  final String betweenText;
  final String privacyPolicyText;
  final Function() onPrivacyPolicyTap;

  final String? secondText;
  final String? activeText;
  final Function()? onActiveTextTap;
  final String? thirdText;
  final String? activeText2;
  final String? firstAdditionalText;
  final Function()? onActiveText2Tap;
  final bool? isSendGlobal;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        text: firstText,
        style: STStyles.body2Medium.copyWith(
          color: SColorsLight().black,
        ),
        children: [
          if (isSendGlobal != null && isSendGlobal!) ...[
            TextSpan(
              text: '\n',
              style: STStyles.body2Medium,
            ),
          ],
          if (firstAdditionalText != null)
            TextSpan(
              text: firstAdditionalText,
            ),
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
          if (secondText != null) ...[
            TextSpan(
              text: secondText!,
            ),
          ],
          if (isSendGlobal != null && isSendGlobal!) ...[
            const TextSpan(
              text: '\n',
              style: TextStyle(
                fontSize: 5.0,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ],
          if (activeText != null) ...[
            _textSpanWithRecognizer(
              text: activeText!,
              onTap: onActiveTextTap!,
            ),
          ],
          if (thirdText != null) ...[
            TextSpan(
              text: thirdText,
            ),
          ],
          if (activeText2 != null) ...[
            _textSpanWithRecognizer(
              text: activeText2!,
              onTap: onActiveText2Tap!,
            ),
          ],
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
