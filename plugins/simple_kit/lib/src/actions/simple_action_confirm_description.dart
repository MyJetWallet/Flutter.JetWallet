import 'package:flutter/material.dart';

import '../../simple_kit.dart';
import '../colors/view/simple_colors_light.dart';

class SActionConfirmDescription extends StatelessWidget {
  const SActionConfirmDescription({
    Key? key,
    required this.text,
  }) : super(key: key);

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
