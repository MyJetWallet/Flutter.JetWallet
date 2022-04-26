import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';
import '../../colors/view/simple_colors_light.dart';

class SimpleDisclaimerRichText extends StatelessWidget {
  const SimpleDisclaimerRichText({
    Key? key,
    required this.firstText,
    required this.onUserAgreementTap,
    required this.onPrivacyPolicyTap,
  }) : super(key: key);

  final String firstText;
  final Function() onUserAgreementTap;
  final Function() onPrivacyPolicyTap;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: firstText,
        style: sCaptionTextStyle.copyWith(
          fontFamily: 'Gilroy',
          color: SColorsLight().black,
        ),
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
