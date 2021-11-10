import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class VerificationDescriptionText extends HookWidget {
  const VerificationDescriptionText({
    Key? key,
    required this.text,
    required this.boldText,
  }) : super(key: key);

  final String text;
  final String boldText;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return RichText(
      text: TextSpan(
        style: sBodyText1Style.copyWith(color: colors.grey1),
        children: [
          TextSpan(
            text: text,
          ),
          TextSpan(
            text: boldText,
            style: sBodyText1Style.copyWith(color: colors.black),
          ),
        ],
      ),
    );
  }
}
