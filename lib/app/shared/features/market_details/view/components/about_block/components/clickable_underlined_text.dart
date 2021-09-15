import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ClickableUnderlinedText extends StatelessWidget {
  const ClickableUnderlinedText({
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
        recognizer: TapGestureRecognizer()..onTap = onTap,
        style: const TextStyle(
          color: Colors.black54,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
