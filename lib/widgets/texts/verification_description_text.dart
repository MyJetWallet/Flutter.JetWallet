import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

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
    final colors = sKit.colors;

    return RichText(
      text: TextSpan(
        style: sBodyText1Style.copyWith(
          color: colors.grey1,
        ),
        children: [
          TextSpan(
            text: text,
          ),
          TextSpan(
            text: boldText,
            style: sBodyText1Style.copyWith(
              color: colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
