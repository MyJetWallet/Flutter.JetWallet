import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

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
    this.secondText,
    this.activeText,
    this.onActiveTextTap,
    this.thirdText,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: firstText,
        style: sCaptionTextStyle.copyWith(
          fontFamily: 'Gilroy',
          color: SColorsLight().black,
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
          if (secondText != null) ...[
            TextSpan(
              text: secondText!,
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
