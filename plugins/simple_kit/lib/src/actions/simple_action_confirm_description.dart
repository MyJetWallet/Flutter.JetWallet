import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';

class SActionConfirmDescription extends StatelessWidget {
  const SActionConfirmDescription({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Baseline(
      baseline: 40.h,
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
