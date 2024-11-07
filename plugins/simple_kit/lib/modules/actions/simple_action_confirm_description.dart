import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import '../../simple_kit.dart';

class SActionConfirmDescription extends StatelessWidget {
  const SActionConfirmDescription({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Baseline(
      baseline: 40.0,
      baselineType: TextBaseline.alphabetic,
      child: Text(
        text,
        maxLines: 10,
        style: sCaptionTextStyle.copyWith(
          color: SColorsLight().grey3,
        ),
      ),
    );
  }
}
