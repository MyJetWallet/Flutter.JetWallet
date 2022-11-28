import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../../simple_kit.dart';

class SClickableLinkText extends StatelessWidget {
  const SClickableLinkText({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: sSubtitle3Style.copyWith(
          fontFamily: 'Gilroy',
          color: SColorsLight().blue,
        ),
        recognizer: TapGestureRecognizer()..onTap = onTap,
      ),
    );
  }
}
