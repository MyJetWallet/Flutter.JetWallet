import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class NoReferralCode extends HookWidget {
  const NoReferralCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Row(
      children: [
        SInfoPressedIcon(
          color: colors.blue,
        ),
        const SpaceW12(),
        Text(
          'I have promo code',
          style: sCaptionTextStyle.copyWith(color: colors.blue),
        ),
      ],
    );
  }
}
