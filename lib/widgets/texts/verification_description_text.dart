import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

class VerificationDescriptionText extends StatelessObserverWidget {
  const VerificationDescriptionText({
    super.key,
    required this.text,
    required this.boldText,
  });

  final String text;
  final String boldText;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return RichText(
      text: TextSpan(
        style: STStyles.body1Medium.copyWith(
          color: colors.gray10,
        ),
        children: [
          TextSpan(
            text: text,
          ),
          TextSpan(
            text: boldText,
            style: STStyles.body1Medium.copyWith(
              color: colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
