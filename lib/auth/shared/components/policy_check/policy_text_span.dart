import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

TextSpan policyTextSpan({
  required String text,
  required Function() onTap,
}) {
  return TextSpan(
    text: text,
    recognizer: TapGestureRecognizer()..onTap = onTap,
    style: const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.underline,
    ),
  );
}
